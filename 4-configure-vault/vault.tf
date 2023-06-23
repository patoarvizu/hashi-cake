resource vault_policy boundary_controller {
  name = "boundary-controller"
  policy = data.vault_policy_document.boundary_controller.hcl
}

resource vault_mount kv {
  path = "secret"
  type = "kv"
}

resource vault_kv_secret vnc_password {
  path = "${vault_mount.kv.path}/vnc"
  data_json = jsonencode(local.vnc_password)
}
