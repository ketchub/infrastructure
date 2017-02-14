variable "digital_ocean_token" {}
variable "ssh_key_id" {}
variable "region" { default = "nyc2" }
variable "droplet_image" { default = "ubuntu-16-04-x64" }
variable "size" { default = "512mb" }
variable "key_path" { default = "~/.ssh/id_rsa" }

provider "digitalocean" {
	token = "${var.digital_ocean_token}"
}

# Homogenous nodes (RethinkDB & App together)
module "homogeneous" {
	source = "./homogeneous"
	source = "./foundation"
	image = "${var.droplet_image}"
	region = "${var.region}"
	size = "4gb"
	ssh_key_id = "${var.ssh_key_id}"
	instances = 3
	key_path = "${var.key_path}"
}

# module "foundation" {
#   source = "./foundation"
#   image = "${var.droplet_image}"
#   region = "${var.region}"
#   size = "${var.size}"
#   ssh_key_id = "${var.ssh_key_id}"
# 	instances = 3
#   key_path = "${var.key_path}"
# }

# RethinkDB nodes
# resource "digitalocean_droplet" "rethinkdb" {
#   ssh_keys            = ["${var.ssh_key_id}"]
#   image               = "${var.ubuntu}"
#   region              = "${var.region}"
#   size                = "512mb"
#   private_networking  = true
#   name                = "rethinkdb${count.index}"
#   count               = "${var.rethinkdb_instances_num}"
#
#   # todo: install rethinkdb
#   # todo: bootstrap consul (agent)
#   # todo: bootstrap nomad (client)
# }
