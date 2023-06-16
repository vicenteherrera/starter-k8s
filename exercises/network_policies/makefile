create_nginx:
	kubectl create deployment nginx --image=nginx

expose_nginx:
	kubectl expose deployment nginx --port=80

test_connection:
	@@echo "To test connection, run in the container:"
	@@echo "wget --spider --timeout=1 nginx"
	kubectl run busybox --rm -ti --image=busybox:1.28 -- /bin/sh

apply_kpn:
	kubectl apply -f https://k8s.io/examples/service/networking/nginx-policy.yaml

apply_calico:
	calicoctl create --filename=./calico/allow-tcp-6379.yaml

delete_calico:
	calicoctl delete --filename=./calico/allow-tcp-6379.yaml
