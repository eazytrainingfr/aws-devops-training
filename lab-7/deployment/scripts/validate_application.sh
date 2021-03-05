#!/bin/bash

# Update PATH
PATH=$PATH:/usr/local/bin
namespace=$(grep -r "namespace" /root/deployment/kustomization.yaml | cut -f2 -d' ')
url=$(kubectl get svc alpinehelloworld-service  --kubeconfig /root/.kube/config -n $namespace -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")
curl http://$url | grep -q "Hello world!"
