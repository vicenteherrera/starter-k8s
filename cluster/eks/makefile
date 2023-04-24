
start:
	@echo "If you get errors from awscli and Kubectl version, get an older one:"
	@echo "curl -LO \"https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl\""
	eksctl create cluster -f eksctl-cluster.yaml

delete:
	# Delete services with external ip 
	# kubectl delete svc <service-name>
	# Delete pod's disruption budget
	# kubectl delete poddisruptionbudget {name} -n {namespace}
	# Delete nodegroup ignoring pod disruption budget
	eksctl delete nodegroup --wait --cluster=eks-test-cluster --name=ng-eks-test-cluster-1 --drain=false --region=eu-north-1
	# Delete cluster
	eksctl delete cluster --wait -f eksctl-cluster.yaml


enable_audit_log:
	@echo "Audit log already enabled on EKS"

kubeconfig:
	aws eks update-kubeconfig --name eks-test-cluster

audit_log:
	aws logs tail "/aws/eks/eks-test-cluster/cluster" --follow

audit_log_pss:
	aws logs tail "/aws/eks/eks-test-cluster/cluster" --filter "FailedCreate"