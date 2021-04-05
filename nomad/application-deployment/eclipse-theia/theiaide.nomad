job {
  update {
    stagger      = "10s"
    max_parallel = 1
  }
  
  group "theiaide" {
    count = 1
    
    network {
      port "http" {}
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
      }
    }
  }
}