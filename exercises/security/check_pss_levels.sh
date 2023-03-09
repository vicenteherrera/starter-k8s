#!/bin/bash

set -e

echo "" > test_psa.log

ALL_NAMESPACES=$(kubectl get namespaces -o name)

for NAMESPACE in $ALL_NAMESPACES 
do

    echo "Checking namespace: $NAMESPACE" | tee -a test_psa.log

    RECOMMENDED="restricted"
    LEVEL="restricted"
    RESTRICTED_OUTPUT=$(kubectl label --dry-run=server --overwrite "$NAMESPACE" pod-security.kubernetes.io/enforce=$LEVEL 2>&1 > /dev/null)
    if [ "$RESTRICTED_OUTPUT" == "" ]; then
        echo "  Restricted: ok" >> test_psa.log
    else
        echo "  Restricted: warnings" >> test_psa.log
        echo "$RESTRICTED_OUTPUT" >> test_psa.log
        RECOMMENDED="baseline"
    fi

    LEVEL="baseline"
    BASELINE_OUTPUT=$(kubectl label --dry-run=server --overwrite "$NAMESPACE" pod-security.kubernetes.io/enforce=$LEVEL 2>&1 > /dev/null)
    if [ "$BASELINE_OUTPUT" == "" ]; then
        echo "  Baseline: ok" >> test_psa.log
    else
        echo "  Baseline: warnings" >> test_psa.log
        echo "$BASELINE_OUTPUT" >> test_psa.log
        RECOMMENDED="privileged"
    fi
    
    echo "  Recommended level: $RECOMMENDED" | tee -a test_psa.log
    echo "-------------------------------------------------------------------" >> test_psa.log

done