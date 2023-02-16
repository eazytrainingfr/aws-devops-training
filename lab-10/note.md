## AWS Load balancer ##

La suite de ces commandes est inspirée de la documentation officielle suivante: 
    - https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/
En cas de soucis avec le code ci après, merci de vous baser sur la documentation la plus à jour
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.6/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json

# Replace "YOUR AWS ACCOUNT ID" by your own ID
eksctl create iamserviceaccount \
--cluster=EKS \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::<YOUR AWS ACCOUNT ID>:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

wget https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.6/v2_4_6_full.yaml
# Update file v2_4_6_full.yaml with cluster name
kubectl apply -f v2_4_6_full.yaml
```



## External DNS ##
[Voici](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/integrations/external_dns/) la documentation officielle.
Après avoir créé la [policy adéquate](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#iam-permissions) dans AWS, effectuer les actions suivantes:

```bash
# Replace "YOUR AWS ACCOUNT ID" by your own ID
eksctl create iamserviceaccount \
    --name external-dns \
    --namespace default \
    --cluster EKS \
    --attach-policy-arn arn:aws:iam::<YOUR AWS ACCOUNT ID>:policy/external-dns-policy \
    --approve \
    --region us-east-1 \
    --override-existing-serviceaccounts

# Téléchargement du manifecte
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.6/docs/examples/external-dns.yaml

# Modifier ce manifeste comme suit:
#   - Supprimer la création du serviceaccount car déja fait
#   - Modifier l'argument domain-filter pour renseigner votre zone DNS
#   - Rassurez vous d'avoir positionne le contexte de sécurité, 
#       Confer l'issue https://github.com/kubernetes-sigs/external-dns/pull/1185#issuecomment-530439786
kubectl apply -f external-dns.yaml
```

