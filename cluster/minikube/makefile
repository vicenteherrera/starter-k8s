
KUBERNETES_VER=1.28.0-rc.1
CPUS=4
MEMORY=7800mb
DISK=20000mb
# See https://github.com/prometheus-operator/kube-prometheus

NETWORK_DEFAULT=""
NETWORK_CALICO="CALICO"
NETWORK_CILIUM="CILIUM"
NETWORK=$(NETWORK_CILIUM)

start:
	minikube delete ||:
	if test "$(NETWORK)" = "$(NETWORK_CALICO)"; then \
		echo "# Using Calico CNI" ; NETPARAM1="--network-plugin=cni" ; NETPARAM2="--cni=calico" ; \
	elif test "$(NETWORK)" = "$(NETWORK_CILIUM)"; then \
		echo "# Using Cilium CNI" ; NETPARAM1="--network-plugin=cni" ; NETPARAM2="" ; \
	fi ; \
	minikube start \
		--kubernetes-version="v${KUBERNETES_VER}" \
		--memory="${MEMORY}" \
		--cpus="${CPUS}" \
		--disk-size="${DISK}" \
		--bootstrapper=kubeadm \
		--extra-config=kubelet.authentication-token-webhook=true \
		--extra-config=kubelet.authorization-mode=Webhook \
		--extra-config=scheduler.bind-address=0.0.0.0 \
		--extra-config=controller-manager.bind-address=0.0.0.0 \
		--extra-config=kubelet.housekeeping-interval=10s $$NETPARAM1 $$NETPARAM2 ; \
	if test "$(NETWORK)" = "$(NETWORK_CILIUM)"; then \
		echo "# Additional Cilium CNI installation step" ; \
		cilium install ; \
	fi
	minikube addons enable metrics-server

kubeconfig:
	minikube update-context

delete:
	minikube delete

enable_audit_log:
	kubectl apply -f ./falco/falco_service.yaml -n falco --wait
	@cd falco && ./minikube_enable_audit_log_falco.sh

audit_log:
	minikube ssh -- tail /var/log/audit/audit.log -f

# Custom targets------

# Use this to tunnel load balancers
tunnel:
	minikube tunnel
