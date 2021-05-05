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

resource "maas_instance" "lxd-host" {
  count = 1

  architecture    = "amd64/generic"
  install_kvm     = false
  register_vmhost = true
  tags            = ["physical", "network_10gb", "sr-iov"]

  user_data = yamlencode(merge(
    local.init_base,
    {
      runcmd = [
        "lxd completion bash > /etc/bash_completion.d/lxd",
      ]
    }
  ))

}
