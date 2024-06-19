terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "4.1.0"
    }
  }
}

provider "vagrant" {}

resource "vagrant_vm" "vagrantbox" {
  env = {
    # To inform terraform about Vagrantfile updates.
    VAGRANTFILE_HASH = md5(file("./Vagrantfile")),
  }
  get_ports = true
}
