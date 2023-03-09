#!/bin/bash

kubectl create secret docker-registry regcred \
    --docker-username=<your-name> \
    --docker-password=<your-pword> \
    --docker-email=<your-email> \
    -n example-ns
