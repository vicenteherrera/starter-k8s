
KUBERNETES_VER=1.28.0
CPUS=4
MEMORY=8g
DISK=20000mb
# See https://github.com/prometheus-operator/kube-prometheus

start:
	minikube delete ||:
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
		--extra-config=kubelet.housekeeping-interval=10s
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
