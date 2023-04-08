apply:
	helmfile apply

init:
	@kubectl -n vault get secret unseal-keys > /dev/null 2>&1 || kubectl -n vault exec vault-0 -- vault operator init -format json -key-shares 1 -key-threshold 1 | tee init.json > /dev/null
	@kubectl -n vault get secret unseal-keys > /dev/null 2>&1 || kubectl -n vault create secret generic unseal-keys --from-file=unseal-keys=init.json
	@rm init.json > /dev/null 2>&1 || true
	@echo "Initialized"

unseal: init
	@kubectl -n vault exec vault-0 -- vault operator unseal $(shell kubectl -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@kubectl -n vault exec vault-1 -- vault operator unseal $(shell kubectl -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@kubectl -n vault exec vault-2 -- vault operator unseal $(shell kubectl -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@echo "Unsealed"

destroy:
	helmfile destroy
	curl -X DELETE http://127.0.0.1:8500/v1/kv/vault/?recurse=true
	kubectl -n vault delete secret unseal-keys