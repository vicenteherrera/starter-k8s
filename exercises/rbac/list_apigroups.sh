#!/bin/bash

# Remember to run on another terminal before this script:
# kubectl proxy

set -euo pipefail

# Show Kubernetes server version
echo -n '# '
kubectl version --short 2>/dev/null | grep 'Server'

for url in $(curl -s http://localhost:8001/ | yq '.paths[]' | xargs) ; do 
    [ "$url" == "/metrics" ] && continue
    doc=$(curl -s http://localhost:8001$url)

    # If URL doesn't publish info, skip
    [ "$doc" == "ok" ] && continue

    # Remove from apiGroup prefix (/, /api/v1, /apis/) and suffix ( /v1, /v1beta1)
    apiGroup=$(echo $url | sed 's/\/api\/v1//' | sed 's/\/apis\///' | sed 's/^\///' | sed 's/\/v[0-9]*\(beta[0-9]\+\)\?$//'  )

    # Get permissions and format them nicely in YAML
    yaml=$(echo "$doc" | yq -M '[.resources[] | {"apiGroups":["'$apiGroup'"], "resources":[.name],"verbs":.verbs}] | .. style="double" | .[].* style="flow"' 2>/dev/null ||:);
    
    # TODO: group resources from the same apiGroup with the same verbs together

    # If document is empty, skip it
    [ "$yaml" == "[]" ] && continue

    echo ""
    echo "# $url"
    echo "$yaml"
done