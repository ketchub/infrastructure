variable "image" {}
variable "region" {}
variable "size" { default = "1gb" }
variable "instances" { default = 1 }
variable "ssh_key_id" {}
variable "key_path" { default = "~/.ssh/id_rsa" }

# Create "foundation" droplets (consul/nomad HA server instances)
resource "digitalocean_droplet" "foundation" {
  ssh_keys            = ["${var.ssh_key_id}"]
	image               = "${var.image}"
  region              = "${var.region}"
  size                = "${var.size}"
  private_networking  = true
	name                = "foundation${count.index}"
  count               = "${var.instances}"

  connection {
    type        = "ssh"
    private_key = "${file("${var.key_path}")}"
    user        = "root"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "${path.module}/../scripts/consul/debian_upstart.conf"
    destination = "/tmp/upstart.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.instances} > /tmp/consul-server-count",
      "echo ${digitalocean_droplet.foundation.0.ipv4_address} > /tmp/consul-server-addr",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/../scripts/consul/install.sh",
      "${path.module}/../scripts/consul/service.sh",
      "${path.module}/../scripts/consul/ip_tables.sh",
    ]
  }
}
