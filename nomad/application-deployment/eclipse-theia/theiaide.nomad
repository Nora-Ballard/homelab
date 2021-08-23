variable "ephemeral_disk_size" {
  type    = number
  default = 500 # MB
}

variable "version" {
  type    = string
  default = "latest"
}

job "theia" {
  region = "global"
  
  datacenters = ["dc1"]
  
  type = "service"
  
  update {
    stagger      = "10s"
    max_parallel = 1
  }
  
  group "ide" {
    count = 1
    
    network {
      mode = "host"
      
      port "http" {
        to = 3000
      }
    }
    
    ephemeral_disk {
      migrate = true
      size    = var.ephemeral_disk_size
      sticky  = true
    }
    
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    
    task "theia" {
      service {
        name = "theia-ide"
        port = "http"

        check {
          type = "http"
          port = "http"
          path = "/"
          interval = "5s"
          timeout  = "2s"
        }
      }
      driver = "docker"

      config {
        image = "theiaide/theia:${var.version}"
        ports = [ "http" ]
        
        mounts = [{
          type     = "bind"
          source   = "local"
          target   = "/home/project"
          readonly = false
        }]
      }
    }
  }
}
