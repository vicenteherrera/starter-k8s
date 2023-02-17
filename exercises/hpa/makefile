
# HPA testing
# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

hpa-deployment-test:
	kubectl apply -f rbac/hpa/test-deployment.yaml

hpa-create:
	kubectl delete hpa php-apache ||:
	kubectl autoscale deployment php-apache --cpu-percent=20 --min=1 --max=10

hpa-rbac:
	kubectl apply -f rbac/hpa/hpa-role.yaml
	kubectl apply -f rbac/hpa/hpa-rolebinding.yaml

hpa-describe:
	watch -n 3 kubectl describe hpa/php-apache

hpa-watch-top:
	watch -n 3 kubectl top pods

hpa-load:
	kubectl run -it load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

# Load using external k6 client

hpa-expose:
	echo "You have to run `minikube tunnel` on a separate terminal"
	kubectl expose deployment php-apache --type=LoadBalancer --name=apache
	minikube service apache --url
	

hpa-k6-load:
	k6 run ./rbac/hpa/k6.js