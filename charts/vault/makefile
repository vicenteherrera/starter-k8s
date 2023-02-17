
all: setup_vault

setup_vault:
	kubectl exec vault-0 -- vault operator init \
		-key-shares=1 \
		-key-threshold=1 \
		-format=json > cluster-keys.json
	jq -r ".unseal_keys_b64[]" cluster-keys.json
	VAULT_UNSEAL_KEY=$$(jq -r ".unseal_keys_b64[]" cluster-keys.json)
	kubectl exec vault-0 -- vault operator unseal $$VAULT_UNSEAL_KEY
	kubectl exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
	kubectl exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
	kubectl exec -ti vault-1 -- vault operator unseal $$VAULT_UNSEAL_KEY
	kubectl exec -ti vault-2 -- vault operator unseal $$VAULT_UNSEAL_KEY