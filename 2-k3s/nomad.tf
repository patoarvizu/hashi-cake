resource nomad_job k3s {
  jobspec = templatefile("${path.module}/k3s.nomad", { token = random_string.token.result })
  detach = false
  hcl2 {
    enabled = true
  }
}