variable "maas_api_key" {
  type        = string
  sensitive   = true
  description = "MAAS API Key"
}

variable "maas_api_url" {
  type        = string
  description = "URI for your MAAS API server http://<MAAS_SERVER>[:MAAS_PORT]/MAAS"
}

variable "vm_host_machine" {
  type        = string
  description = "MAAS Machine Name of the VM Host"
}
