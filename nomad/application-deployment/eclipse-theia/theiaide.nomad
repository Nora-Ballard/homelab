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
      size    = 500 # MB
      sticky  = true
    }
    
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    
    task "theia" {
      driver = "docker"

      config {
        image = "theiaide/theia:latest"
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
