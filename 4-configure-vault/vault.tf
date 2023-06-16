resource vault_auth_backend userpass {
  type = "userpass"
}

resource vault_generic_endpoint boundary_user {
  depends_on = [ vault_auth_backend.userpass ]
  path = "auth/userpass/users/boundary"
  ignore_absent_fields = true
  data_json = jsonencode(local.boundary_user_data_json)
}

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
