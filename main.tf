
data "nomad_job_parser" "theia_ide" {
  hcl = file("${path.module}/nomad/application-deployment/eclipse-theia/theiaide.nomad")
}

resource "nomad_job" "theia_ide" {
  jobspec = data.nomad_job_parser.theia_ide.hcl

  hcl2 {
    enabled = "true"
    vars = {
      ephemeral_disk_size = "400" # MB
      version             = "latest"
    }
  }
}
