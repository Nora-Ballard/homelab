terraform {
  required_providers {
    maas = {
      source = "ionutbalutoiu/maas"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
    template = {
      source = "hashicorp/template"
      version = "~>2.2"
    }
  }
}

locals {
  init_base = {
    timezone         = "America/Chicago"
    byobu_by_default = "system"

    packages = [
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

data "template_cloudinit_config" "kubernetes" {
  gzip = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = yamlencode(local.init_base)
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-config/kubernetes-core.yaml", {})
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
  
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-config/kubernetes-docker.yaml", {})
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
}

resource "maas_instance" "kubernetes" {
  count = 3

  allocate_params {
    min_cpu_count = 2
    min_memory = 8192 # MB
  }

  deploy_params {
    user_data = data.template_cloudinit_config.kubernetes.rendered
  }
}
