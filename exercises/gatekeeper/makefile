delete_constraints-helm:
	helm delete constraints -n gatekeeper

deploy_privileged_tenant:
	kubectl apply -f ./privileged-pod.yaml -n tenant
	
delete_privileged_tenant:
	kubectl delete .f ./privileged-pod.yaml -n tenant

tamper_privileged_constraint:
	kubectl apply -f ./c-privileged-container-tampered.yaml