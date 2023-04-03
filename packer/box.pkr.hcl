source "vagrant" "box" {
  communicator = "ssh"
  source_path = "bento/ubuntu-20.04"
  box_version = "v202303.13.0"
  provider = "virtualbox"
}

build {
  sources = ["source.vagrant.box"]

  provisioner "shell" {
    script = "provision.sh"
  }
}