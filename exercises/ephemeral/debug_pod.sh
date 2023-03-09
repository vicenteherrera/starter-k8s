#!/bin/bash

kubectl debug "$1" -it --image=ubuntu --target=app-container

# kubectl debug "$1" -it --image=ubuntu --share-processes --copy-to=app-container-debug

# https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/
# https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
# https://itnext.io/distroless-container-debugging-on-k8s-openshift-e418fd66fdad
# https://stackoverflow.com/questions/73355970/how-to-get-access-to-filesystem-with-kubectl-debug-ephemeral-containers

# minikube ssh
# docker container ls | grep "app-container"
# container=
# docker container inspect $container | jq '.[0].State.Pid'
# pid=
# sudo cat /proc/$pid/root/var/mysecrets/token
