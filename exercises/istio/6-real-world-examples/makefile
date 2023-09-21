
install:
	getmesh fetch 1.10.3
	getmesh istioctl install --set profile=demo
	kubectl label namespace default istio-injection=enabled
	git clone https://github.com/GoogleCloudPlatform/microservices-demo.git ||:
	kubectl apply -f microservices-demo/release/kubernetes-manifests.yaml
	kubectl apply -f microservices-demo/istio-manifests

prepare:
	kubectl delete frontend-external ||:
	@echo "Changing original deployment for one that includes label version=original"
	kubectl delete deploy frontend ||:
	sleep 5
	kubectl create -f frontendoriginal-210119-085856.yaml
	@echo "Deploying destionation rule for subsets original and v1"
	kubectl create -f frontenddr-210119-085856.yaml
	@echo "Deploying virtual service routing traffic to original"
	kubectl apply -f frontendv1-210119-085856.yaml

v1:
	@echo "Deploying v1 deployment"
	kubectl apply -f frontendv1-210119-085856.yaml
	@echo "Deploying virtual service routing 70% traffic to original and 30% to v1"
	kubectl apply -f frontend30-210119-085856.yaml

kiali:
	istioctl dash grafana

fault:
	kubectl apply -f recommendationdelay-210119-085953.yaml

grafana:
	istioctl dash grafana

abort:
	kubectl apply -f productcatalogserviceabort-210119-085953.yaml

delay:
	@echo "Add delay of 5 s to deployment productcatalogservice"
	@echo "Add env variable EXTRA_LATENCY with value 6s to the container"
	@read -p "Press enter to start... " dummy
	kubectl edit deploy productcatalogservice

timeout:
	kubectl apply -f productcatalogservice-timeout.yaml

retry:
	kubectl apply -f productcatalogservice-retry.yaml

zipkin:
	istioctl dash zipkin