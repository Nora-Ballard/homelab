provider "nomad" {
  address = "http://localhost:4646"
  region  = var.region
}

provider "consul" {
  address    = "localhost:8300"
  datacenter = "dc1"
}
