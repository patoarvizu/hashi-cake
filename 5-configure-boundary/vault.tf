resource vault_token boundary {
  policies = [ "boundary-controller" ]
  renewable = true
  ttl = "24h"
  no_parent = true
  period = "24h"
}