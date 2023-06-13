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

resource vault_policy boundary {
  name = "boundary"
  policy = data.vault_policy_document.boundary.hcl
}

resource vault_database_secrets_mount postgres {
  path = "db"
  postgresql {
    name = "boundary"
    username = "postgres"
    password = "admin123"
    username_template = "{{ .RoleName }}-{{ random 8 }}"
    connection_url = "postgresql://{{username}}:{{password}}@postgres-postgresql.boundary:5432/boundary?sslmode=disable"
    verify_connection = true
    allowed_roles = [
      "boundary",
    ]
  }
}

resource vault_database_secret_backend_role boundary {
  name = "boundary"
  backend = vault_database_secrets_mount.postgres.path
  db_name = vault_database_secrets_mount.postgres.postgresql[0].name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
  ]
}

resource vault_mount kv {
  path = "secret"
  type = "kv"
}

resource vault_kv_secret vnc_password {
  path = "${vault_mount.kv.path}/vnc"
  data_json = jsonencode(local.vnc_password)
}
