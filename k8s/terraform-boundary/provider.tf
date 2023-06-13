provider boundary {
  addr= "http://localhost:9200"
  recovery_kms_hcl = "${path.module}/files/recovery.hcl"
}

provider kubernetes {}

provider vault {
  address = "http://localhost:8200"
  token = jsondecode(nonsensitive(data.kubernetes_secret_v1.unseal_keys.data)["unseal-keys"])["root_token"]
  skip_child_token = true
}