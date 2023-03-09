#!/bin/bash
set -euo pipefail

# kubectl create secret generic my-token \
#     -n example-ns \
#     --from-file=./token \

kubectl create secret generic my-token \
    -n example-ns \
    --from-literal=token=${EXAMPLE_TOKEN} \

