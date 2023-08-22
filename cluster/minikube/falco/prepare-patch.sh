#!/bin/bash

echo "Creating temp dir"

TMPDIR=$(mktemp -d -t "kube-apiserver.XXXXXXXX")
if [ ! -e "$TMPDIR" ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi

echo "Getting kube-apiserver.yaml from minikube"
minikube ssh "sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml" >$TMPDIR/kube-apiserver.yaml

echo "Modifying kube-apiserver.yaml"

search="- kube-apiserver"
insert="    - --audit-policy-file=/var/lib/k8s_audit/audit-policy.yaml
    - --audit-log-path=/var/log/audit/audit.log"
insert=${insert//$'\n'/\\n}
sed "/^.*$search.*"'/a\'"$insert" $TMPDIR/kube-apiserver.yaml >$TMPDIR/kube-apiserver2.yaml

search="volumeMounts:"
insert="    - mountPath: /var/lib/k8s_audit/audit-policy.yaml
      name: audit
      readOnly: true
    - mountPath: /var/log/audit/audit.log
      name: audit-log
      readOnly: false"
insert=${insert//$'\n'/\\n}
sed "/^.*$search.*"'/a\'"$insert" $TMPDIR/kube-apiserver2.yaml >$TMPDIR/kube-apiserver3.yaml

search="volumes:"
insert="  - name: audit
    hostPath:
      path: /var/lib/k8s_audit/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/audit/audit.log
      type: FileOrCreate"
insert=${insert//$'\n'/\\n}
sed "/^.*$search.*"'/a\'"$insert" $TMPDIR/kube-apiserver3.yaml >$TMPDIR/kube-apiserver-patched.yaml

# echo "Creating patch kube-apiserver.diff"
# diff -u $TMPDIR/kube-apiserver.yaml $TMPDIR/kube-apiserver-patched.yaml >$TMPDIR/kube-apiserver.diff

echo "Uploading patched file to minikube"
minikube cp $TMPDIR/kube-apiserver-patched.yaml minikube:/home/docker/kube-apiserver-patched.yaml

echo "Cleaning up temp dir $TMPDIR"
rm -r $TMPDIR
