resource boundary_scope organization {
  name = "organization"
  scope_id = "global"
}

resource boundary_scope project {
  name = "project"
  scope_id = boundary_scope.organization.id
}

resource boundary_auth_method_password userpass {
  scope_id = "global"
}

resource boundary_account_password demo {
  auth_method_id = boundary_auth_method_password.userpass.id
  type = "password"
  login_name = "demo"
  password = "demo1234"
}

resource boundary_user demo {
  account_ids = [ boundary_account_password.demo.id ]
  scope_id = "global"
}

resource boundary_group demo {
  member_ids = [ boundary_user.demo.id ]
  scope_id = "global"
}

resource boundary_role demo_global {
  scope_id = "global"
  grant_scope_id = "global"
  principal_ids = [ boundary_group.demo.id ]
  grant_strings = [ "id=*;type=*;actions=*" ]
}

resource boundary_role demo_org {
  scope_id = "global"
  grant_scope_id = boundary_scope.organization.id
  principal_ids = [ boundary_group.demo.id ]
  grant_strings = [ "id=*;type=*;actions=*" ]
}

resource boundary_role demo_project {
  scope_id = "global"
  grant_scope_id = boundary_scope.project.id
  principal_ids = [ boundary_group.demo.id ]
  grant_strings = [ "id=*;type=*;actions=*" ]
}

resource boundary_host_catalog_static demo {
  scope_id = boundary_scope.project.id
}

resource boundary_host_static demo {
  address = "kubedoom.kubedoom.svc"
  host_catalog_id = boundary_host_catalog_static.demo.id
}

resource boundary_host_set_static demo {
  host_catalog_id = boundary_host_catalog_static.demo.id
  host_ids = [
      boundary_host_static.demo.id,
  ]
}

resource boundary_target demo {
  name = "demo"
  description = "Demo"
  type = "tcp"
  scope_id = boundary_scope.project.id
  session_connection_limit = -1
  default_port = 5900
  host_source_ids = [
    boundary_host_set_static.demo.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.demo.id
  ]
}

resource boundary_credential_store_vault vault {
  name = "vault"
  description = "Vault"
  address = "http://vault.vault.svc:8200"
  token = vault_token.boundary.client_token
  scope_id = boundary_scope.project.id
}

resource boundary_credential_library_vault demo {
  name = "demo"
  description = "Demo"
  credential_store_id = boundary_credential_store_vault.vault.id
  path = "secret/vnc"
}