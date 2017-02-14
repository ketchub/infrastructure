variable "image" {}
variable "region" {}
variable "size" { default = "1gb" }
variable "instances" { default = 1 }
variable "ssh_key_id" {}
variable "key_path" { default = "~/.ssh/id_rsa" }

# Create "homogeneous" droplets (all-in-ones)
resource "digitalocean_droplet" "homogeneous" {
  ssh_keys            = ["${var.ssh_key_id}"]
	image               = "${var.image}"
  region              = "${var.region}"
  size                = "${var.size}"
  private_networking  = true
	name                = "homogeneous${count.index}"
  count               = "${var.instances}"

  connection {
    type        = "ssh"
    private_key = "${file("${var.key_path}")}"
    user        = "root"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/../../scripts/rethinkdb/install.sh",
      "${path.module}/../../scripts/docker/install.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "echo bind=all >> /etc/rethinkdb/instances.d/cluster.conf",
      "echo 'join=${digitalocean_droplet.homogeneous.0.ipv4_address}:29015' >> /etc/rethinkdb/instances.d/cluster.conf",
      "/etc/init.d/rethinkdb restart"
    ]
  }
}

output "homogeneous_ips" {
  value = "${join(",", digitalocean_droplet.homogeneous.*.ipv4_address)}"
}
