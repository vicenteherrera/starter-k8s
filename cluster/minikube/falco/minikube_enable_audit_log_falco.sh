#!/bin/bash

# https://medium.com/trendyol-tech/how-to-enable-kubernetes-auditing-feature-in-minikube-running-locally-e45f0d68ff82

set -e

echo "Enabling Kubernetes Audit Log on Minikube"

# curl -sLO https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/audit/audit-policy.yaml

# minikube ssh "curl -sLO https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/audit/audit-policy.yaml"
minikube cp audit-policy.yaml minikube:/home/docker/audit-policy.yaml
minikube cp webhook-config.yaml minikube:/home/docker/webhook-config.yaml
minikube ssh "sudo mkdir -p /var/lib/k8s_audit /var/log/audit"
minikube ssh "sudo mv audit-policy.yaml /var/lib/k8s_audit"

echo "Applying patch to kube-apiserver.yaml"
# minikube cp kube-apiserver.diff minikube:/home/docker/kube-apiserver.diff
# minikube ssh "sudo patch /etc/kubernetes/manifests/kube-apiserver.yaml < kube-apiserver-patch.diff"
source ./prepare-patch.sh
minikube ssh "sudo cp /home/docker/kube-apiserver-patched.yaml /etc/kubernetes/manifests/kube-apiserver.yaml"

echo "Waiting for control plane to reboot and audit.log file to have content"
minikube ssh 'while ! [ -s /var/log/audit/audit.log ]; do echo -n "." ; sleep 3 ; done'
echo ""
echo "Audit log enabled"
