terraform {
  required_providers {
    maas = {
      source = "suchpuppet/maas"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

resource "maas_instance" "lxd-host" {
  count = 1

  architecture    = "amd64/generic"
  install_kvm     = false
  register_vmhost = true
  tags            = ["physical", "network_10gb", "sr-iov"]

  user_data = templatefile("${path.module}/templates/cloud-init-lxd-host.tpl", {})
}

resource "random_password" "lxd_trust" {
  length           = 20
  special          = true
  override_special = "_%@"
}
