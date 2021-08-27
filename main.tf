terraform {
  required_providers {
    maas = {
      source = "ionutbalutoiu/maas"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

locals {
  init_base = {
    timezone         = "America/Chicago"
    byobu_by_default = "system"

    package = [
      "bash-completion",
      "etckeeper",
    ]

    runcmd = [
      "systemctl mask ctrl-alt-del.target && systemctl daemon-reload"
    ]
  }
}

resource "maas_vm_host" "lxd" {
  type                     = "lxd"
  machine                  = var.vm_host_machine
  memory_over_commit_ratio = 2
}
