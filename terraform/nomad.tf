resource nomad_job k3s {
  jobspec = templatefile("${path.module}/k3s.nomad", { token = random_string.token.result })
  hcl2 {
    enabled = true
  }
}