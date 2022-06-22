# gke-terraform
## Remediation use case problem statement:
Ensure that your Google Kubernetes Engine (GKE) clusters are using automatic upgrades for their nodes.
1. Remediation resource: GKE cluster node pool
2. Resource parameter: auto upgrade 

## Why remediation:
Older versions get deprecated as communities release newer versions so to avoid using deprecated version we should have auto upgrade enabled on node pools.

## Reference to the use-case id in spreadsheet
Remediation use cases - Google Cloud - #2

## Pre-requisites to setup GKE cluster:
1. Enable Google Cloud APIs
```
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```
2. Create service account
```
gcloud iam service-accounts create <service-account-name>
```
3. Grant necessary roles to service account to create GKE cluster and associated resources
```
gcloud projects add-iam-policy-binding <project-name> --member serviceAccount:<service-account-name>@<project-name>.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding <project-name> --member serviceAccount:<service-account-name>@<project-name>.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding <project-name> --member serviceAccount:<service-account-name>@<project-name>.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding <project-name> --member serviceAccount:<service-account-name>@<project-name>.iam.gserviceaccount.com --role roles/container.admin

```
4. Create and download a key file that terraform will use to authenticate
```
gcloud iam service-accounts keys create terraform-gkecluster-keyfile.json --iam-account=<service-account-name>@<project-name>.iam.gserviceaccount.com
```
5. Export GOOGLE_APPLICATION_CREDENTIALS
```
export GOOGLE_APPLICATION_CREDENTIALS=/tmp/key.json
```

## Details about variables used:
1. Variables used in infra
- project
- region
- zone
2. Variables used in remediation
- project
- region
- zone
3. Variables used in identify remediation
- cluster
- location
- project
- service_account_file

## Setup GKE cluster for testing:
1. For setup we will use main.tf and variables-setup.tfvars files from infra directory.
2. Run below commands to setup GKE cluster
```
terraform init
terraform plan -var-file=variables-setup.tfvars
terraform apply -var-file=variables-setup.tfvars
``` 

## Identify Remediation:
1. To identify remediation we will use identify-auto-upgrade.yaml and verify-auto-upgrade.py files from verify-auto-upgrade directory
2. When we execute ansible playbook identify-auto-upgrade.yaml it will check if auto upgrade is enabled or disabled and will print specific message. 
3. Run below commands to identify remediation
```
ansible-playbook identify-auto-upgrade.yaml --extra-vars '{"cluster":"cloudmatos-gke", "location":"us-east1-b", "project":"cloudmatos", "service_account_file":"/home/chetank/cloudmatos/cloudmatos-0827bd9dfe5f.json"}' -vvv
```

## Remediation Solution:
1. We will enable auto upgrade on node pool using terraform script
2. For remediation solution we will have to use terraform.tfstate file of infra setup as we will be updating existing resources with new terraform script.

## Remediation Steps:
1. For remediation we will use main.tf and variables-remediation.tfvars files from remediation directory.
2. Run below commands for remediation
```
terraform init
terraform plan -var-file=variables-remediation.tfvars -state=../infra/terraform.tfstate
terraform apply -var-file=variables-remediation.tfvars -state=../infra/terraform.tfstate
```

## Steps to destroy the GKE cluster setup:
```
   terraform plan -destroy
   terraform apply -destroy
```
Note: When we use both above commands for destroy we will need to enter project id.
