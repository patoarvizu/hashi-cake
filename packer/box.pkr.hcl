source "vagrant" "box" {
  communicator = "ssh"
  source_path = "bento/ubuntu-20.04"
  provider = "virtualbox"
}

build {
  sources = ["source.vagrant.box"]

  provisioner "shell" {
    script = "provision.sh"
  }
}