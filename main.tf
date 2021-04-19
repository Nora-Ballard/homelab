terraform {
  required_providers {
    maas = {
      source  = "suchpuppet/maas"
      version = "3.1.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

resource "maas_instance" "lxd-host" {
  count        = 1
  architecture = "amd64/generic"
  # memory       = 30                                     # ? Is this in GB
  install_kvm  = true
  tags         = ["physical","network_10gb","sr-iov"]

  user_data = templatefile("${path.module}/templates/cloud-init-lxd-host.tpl", {
    trust_password              = random_password.lxd_trust.result
    maas_api_key                = var.maas_api_key
    maas_api_url                = var.maas_api_url
    maas_subnet_name_ipv4       = "SERVER"
    images_auto_update_interval = 6
    bridge_interface_name       = "lxdbr0"
  })
}

resource "random_password" "lxd_trust" {
  length           = 20
  special          = true
  override_special = "_%@"
}
