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
  count = 1

  architecture = "amd64/generic"
  install_kvm  = false # Do not use virsh, we are using lxd
  tags         = ["physical", "network_10gb", "sr-iov"]

  user_data = templatefile("${path.module}/templates/cloud-init-lxd-host.tpl", {
    trust_password              = random_password.lxd_trust.result
    maas_api_key                = var.maas_api_key
    maas_api_url                = var.maas_api_url
    maas_subnet_name_ipv4       = "SERVER"
    images_auto_update_interval = 6
    bridge_interface_name       = "lxdbr0"
  })
}
# TODO: Update the provider to add the register_vmhost=True value, that was added in v3.0 beta-3
#       https://discourse.maas.io/t/maas-3-0-beta3-has-been-released/4454
# TODO: See if there is a way for the host to register itself.

resource "random_password" "lxd_trust" {
  length           = 20
  special          = true
  override_special = "_%@"
}
