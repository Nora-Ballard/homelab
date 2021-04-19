provider "maas" {
  api_version = "2.0"
  api_key     = var.maas_api_key
  api_url     = var.maas_api_url
}

provider "random" {}