## ----------------------------------------------------------------------
## Test Calico GlobalNetworkPolicies and Kubernetes Network Policies
## ----------------------------------------------------------------------

all: reset create_ns install_web install_shell_pod  ## Creates test namespace, redis and debug pod
	@$(MAKE) -s POD_LABEL="app=web" wait_pod_ready

help:     			## Show this help.
	@sed -ne '/@sed/!s/:.*##//p' $(MAKEFILE_LIST) | column -tl 2

check_calico: 		## Checks what Calico client and server version is running
	calicoctl version

create_ns: 			## Creates test namespace and makes it the default
	kubectl create namespace test-net
	kubens test-net

install_web:		## Deploys web server on current namespace
	kubectl apply -f ./web.yaml

install_shell_pod: 	## Deploy debug curl pod on current namespace
	kubectl run debug --image=curlimages/curl --restart=Never --labels="app=web" -- sh -c 'while true; do nslookup web-service.test-net.svc.cluster.local ; i=0 ; while ! nc -zv web-service.test-net.svc.cluster.local 80 -w 1 && [ $$i -lt 7 ] ; do echo -n "." ; i=$$((i+1)) ; done ; done'

# Test targets:

test_web:
	@kubectl exec debug -it -- sh -c 'nslookup web-service.test-net.svc.cluster.local ; i=0 ; while ! nc -zv web-service.test-net.svc.cluster.local 80 -w 1 && [ $$i -lt 7 ] ; do echo -n "." ; i=$$((i+1)) ; done'

test_web2:				## Test connection from debug pod to web server
	kubectl exec debug -it -- curl http://web-service.test-net.svc --insecure -s -o /dev/null -v --connect-timeout 5  --retry 5 --retry-max-time 120

test_kube_api:			## Test connection from debug pod to Kubernetes API
	kubectl exec debug -it -- curl https://kubernetes.default.svc --insecure --connect-timeout 5

# Network policies

calico_install_ingress:		## Install Calico network policies from ingress/calico/
	calicoctl apply --allow-version-mismatch -f ./ingress/calico/ ||:

calico_install_egress:		## Install Calico network policies from egress/calico/
	calicoctl apply --allow-version-mismatch -f ./egress/calico/ ||:

calico_install_egress2:		## Install Calico network policies from egress2/calico2/
	calicoctl apply --allow-version-mismatch -f ./egress2/calico/ ||:

calico_install_egress3:		## Install Calico network policies from egress3/calico/
	calicoctl apply --allow-version-mismatch -f ./egress3/calico/ ||:

knp_install_ingress:	## Install Kubernetes network policy from ingress/ingress-allow-ns.yaml
	kubectl apply -f ./ingress/ingress-allow-ns.yaml

knp_install_egress2:	## Install Kubernetes network policy from egress2/egress-allow-ns.yaml
	kubectl apply -f ./egress2/egress-allow-ns.yaml

knp_install_egress3:	## Install Kubernetes network policy from egress3/egress-allow-ns.yaml
	kubectl apply -f ./egress3/egress-allow-ns.yaml

calico_delete:		## Delete Calico network policies
	calicoctl delete -f ./ingress/calico/ --allow-version-mismatch ||:
	calicoctl delete -f ./egress/calico/ --allow-version-mismatch ||:
	calicoctl delete -f ./egress2/calico/ --allow-version-mismatch ||:
	calicoctl delete -f ./egress3/calico/ --allow-version-mismatch ||:

knp_delete:	## Delete Kubernetes network policies
	kubectl delete -f ./ingress/ingress-allow-ns.yaml ||:
	kubectl delete -f ./egress2/egress-allow-ns.yaml ||:
	kubectl delete -f ./egress3/egress-allow-ns.yaml ||:

np_delete_all: calico_delete knp_delete ## Delete Calico and Kubernetes network policies

# Label test namespace

label_ns:				## Label test namespace with allow-egress=disabled
	kubectl label ns test-net allow-egress=disabled

remove_label_ns:		## Removes label allow-egress from test namespace
	kubectl label ns test-net allow-egress-

# Reset the test

reset: np_delete_all ## Reset the test, deleting the test namespace 
	kubens default
	kubectl delete namespace test-net ||:

# Utils

wait_pod_ready:
	@echo "Waiting pods with label ${POD_LABEL} to be running"
	@while test "$$(kubectl get pods -l ${POD_LABEL} --field-selector=status.phase!=Running -oname)" != "" ; \
		do echo -n "." && sleep 1; \
		done; \
		echo ""
