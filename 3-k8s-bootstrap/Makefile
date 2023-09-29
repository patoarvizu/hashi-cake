apply: tf-init
	terraform apply -auto-approve

tf-init:
	terraform init

init:
	@kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault get secret unseal-keys > /dev/null 2>&1 || kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault exec vault-0 -- vault operator init -format json -key-shares 1 -key-threshold 1 | tee init.json > /dev/null
	@kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault get secret unseal-keys > /dev/null 2>&1 || kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault create secret generic unseal-keys --from-file=unseal-keys=init.json
	@rm init.json > /dev/null 2>&1 || true
	@echo "Initialized"

unseal: init
	@kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault exec vault-0 -- vault operator unseal $(shell kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault exec vault-1 -- vault operator unseal $(shell kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault exec vault-2 -- vault operator unseal $(shell kubectl --kubeconfig=${HOME}/.nomad-k3s/config -n vault get secret unseal-keys -o json | jq -r '.data["unseal-keys"]' | base64 -d | jq -r '.unseal_keys_hex[0]')
	@echo "Unsealed"