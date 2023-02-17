# RBAC testing

rbac: create-user deploy-roles deploy-role-scale
	kubectl apply -f rbac/scale-deployment.yaml
	@$(MAKE) -s switch-user1

create-user:
	@mkdir -p rbac && cd rbac && \
	openssl genrsa -out user1.key 2048 && \
	openssl req -new -key user1.key -out user1.csr -subj '/CN=user1/O=group1' && \
	openssl x509 -req -in user1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out user1.crt -days 500 && \
	cp user1.key ~/.minikube/user1.key && \
	cp user1.csr ~/.minikube/user1.csr && \
	kubectl config set-credentials user1 --client-certificate=user1.crt --client-key=user1.key && \
	kubectl config set-context user1-minikube --namespace=tennant --user=user1
		
deploy-roles:
	kubectl apply -f rbac/role.yaml
	kubectl apply -f rbac/rolebinding.yaml

deploy-role-scale:
	kubectl apply -f rbac/role-scale.yaml --user=minikube 
	kubectl apply -f rbac/rolebinding-scale.yaml --user=minikube 

scale-up:
	kubectl scale --replicas=3 deployment/scale-deployment

scale-down:
	kubectl scale --replicas=1 deployment/scale-deployment

can-i-user1:
	kubectl auth can-i --list --as=user1

switch-user1:
	kubectl config set-context user1-minikube --namespace=tennant --user=user1
	kubectl config use-context user1-minikube

