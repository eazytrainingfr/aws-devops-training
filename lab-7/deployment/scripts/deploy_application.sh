#!/bin/bash

# Update PATH
PATH=$PATH:/usr/local/bin/
cp alpinehelloworld/kustomization.yaml /root/deployment/
# retrieve aks config file for credentials management
aws eks --region us-east-1 update-kubeconfig --name EKS
namespace=$(grep -r "namespace" /root/deployment/kustomization.yaml | cut -f2 -d' ')
kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --validate=true --dry-run=client --kustomize=/root/deployment/
kubectl apply --kustomize=/root/deployment/
