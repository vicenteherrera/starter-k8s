
create_cronjobs:
	@$(MAKE) -s create_namespace NAMESPACE=tenant
	@$(MAKE) -s cronjob_single NAME=psp CHANCE=5000 FREQ=5
	@$(MAKE) -s cronjob_single NAME=netpolicy CHANCE=8500 FREQ=5
	@$(MAKE) -s cronjob_single NAME=admission CHANCE=8500 FREQ=5

delete_cronjobs:
	kubectl delete cronjob sec-test-psp -n tenant
	kubectl delete cronjob sec-test-netpolicy -n tenant
	kubectl delete cronjob sec-test-admission -n tenant

create_mock_jobs:
	@echo "This will create some mock Kubernetes jobs spaced minutes time"
	@$(MAKE) -s create_namespace NAMESPACE=tenant
	@$(MAKE) -s job_single NAME=psp
	@$(MAKE) -s job_single NAME=netpolicy
	@$(MAKE) -s job_single NAME=admission

job_single:
	@command -v envsubst > /dev/null || ( echo "envsubst command required" && exit 1 )
	@echo "Launching job $$NAME"
	cat ./exampleJob.yaml.in | \
		NAME=$$NAME envsubst '$$NAME' | \
		kubectl create -n tenant -f -

cronjob_single:
	cat ./exampleCronJob.yaml.in | \
		NAME=$$NAME CHANCE=$$CHANCE FREQ=$$FREQ envsubst '$$NAME $$CHANCE $$FREQ' | \
		kubectl apply -n tenant -f -

create_namespace:
	@kubectl create namespace "$$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
