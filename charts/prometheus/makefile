show_audit_violations:
	@echo "k8srequiredlabels.constraints.gatekeeper.sh/ns-must-have-gk"
	@kubectl describe k8srequiredlabels.constraints.gatekeeper.sh/ns-must-have-gk | \
		grep -A999999 -e ' Violations:'
	@echo "privilegedcontainers.constraints.gatekeeper.sh/privileged-container"
	@kubectl describe privilegedcontainers.constraints.gatekeeper.sh/privileged-container | \
		grep -A999999 -e ' Violations:'

log_gk_audit:
	stern -n gatekeeper "gatekeeper-audit*"

log_gk_controller_violations:
	stern -n gatekeeper "gatekeeper-controller-*" | grep -i -E 'denied admission'

log_kube_ac_denied:
	minikube ssh -- tail /var/log/audit/audit.log -f | grep 'denied the request'

log_kube_psa_denied:
	minikube ssh -- tail /var/log/audit/audit.log -f | grep 'FailedCreate'