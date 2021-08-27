output "kubernetes" {
  value = maas_instance.kubernetes.*.fqdn
}
