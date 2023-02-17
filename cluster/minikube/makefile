

# See https://github.com/prometheus-operator/kube-prometheus
start:
	minikube delete ||:
	minikube start \
		--kubernetes-version=v1.23.0 --memory=6g --cpus 4 \
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