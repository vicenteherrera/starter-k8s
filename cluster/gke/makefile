
CLUSTER_NAME=starter-k8s
REGION=europe-southwest1-a


start: start_calico
# --no-enable-ip-alias
# --cluster-ipv4-cidr #1008 nodes

start_calico: CNI_PARAMS = --enable-network-policy
start_calico: start_cluster check_calico

start_cilium: CNI_PARAMS = --enable-dataplane-v2 --enable-ip-alias
start_cilium: start_cluster check_cilium

start_cluster:
	gcloud container clusters create "${CLUSTER_NAME}" \
		--region="${REGION}" \
		--cluster-version=1.25 \
  		--tags=game-server \
  		--scopes=gke-default \
  		--num-nodes=3 \
  		--no-enable-autoupgrade \
  		--enable-image-streaming \
  		--machine-type=e2-standard-4 \
		${CNI_PARAMS}

#  --internal-ip

check_cilium:
	kubectl get pods -l k8s-app=cilium -n kube-system

check_calico:
	kubectl get nodes -l projectcalico.org/ds-ready=true

# gcloud

gcloud_info:
	@@echo "gcloud project: $$(gcloud config get-value project)"
	@@echo "region: ${REGION}"
	@@echo "cluster name: ${CLUSTER_NAME}"
	@@echo "checking kubernetes API enabled"
	@@gcloud services list --filter=container.googleapis.com

# Kubeconfig

kubeconfig:
	gcloud container clusters get-credentials "${CLUSTER_NAME}" --region="${REGION}"

kubeconfig_auth_setup:
	gcloud components install gke-gcloud-auth-plugin

kubeconfig_auth_setup_apt:
	sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

# Other

delete:
	gcloud container clusters delete "${CLUSTER_NAME}" \
	--region="${REGION}" 

enable_audit_log:
	@echo "Audit log installation not implemented in this script"

audit_log:
	@echo "Getting audit log not implemented in this script"