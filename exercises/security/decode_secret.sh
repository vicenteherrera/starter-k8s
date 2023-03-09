#!/bin/bash

token=$(kubectl get secret my-token -n example-ns -o jsonpath='{.data.token}')
echo "Base 64 secret content:"
echo $token
echo "Decode secret:"
echo -n $token | base64 --decode