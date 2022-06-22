# gke-terraform
## Remediation use case problem statement:
Ensure that your Google Kubernetes Engine (GKE) clusters are using automatic upgrades for their nodes.
1. Remediation resource: GKE cluster node pool
2. Resource parameter: auto upgrade 

## Why remediation:
Older versions get deprecated as communities release newer versions so to avoid using deprecated version we should have auto upgrade enabled on node pools.

## Reference to the backlog / use-case id in spreadsheet
Remediation use cases - Google Cloud - #2

## Pre-requisites to setup Cloud SQL instance:
- ###### Enable Cloud SQL Admin Api using gcp console.
- ###### Create service account and assign CloudSQLAdmin role to that service account using below commands:
```
  gcloud iam service-accounts create sa-terraform --display-name "Terraform service account"
  gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:sa-terraform@PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin"
```
- ###### Create service account key which will be used by terraform:
```
  gcloud iam service-accounts keys create key.json --iam-account sa-terraform@PROJECT_ID.iam.gserviceaccount.com
```
- ###### Export GOOGLE_APPLICATION_CREDENTIALS:
```
  export GOOGLE_APPLICATION_CREDENTIALS=key.json
```

## Variables inside variables-setup.tfvars file (Used for Cloud SQL setup)
```
  project = "project_id"
  region = "region"
  password = "password"
  cidr-name = "open-to-all"
  cidr ="0.0.0.0/0"
```

## Steps for creating Cloud SQL instance using terraform script:
We need to use variables-setup.tfvars and main.tf files to setup Cloud SQL instance which is open to internet: 
```
   terraform init ==>(Initialize working directory)
   terraform plan -var-file=variables-setup.tfvars ==>(Shows which resources will be created)
   terraform apply -var-file=variables-setup.tfvars ==>(Creates resources)
```

## Remediation Solution:
We will restrict SQL instance access to our private network only using terraform.

## Variables inside variables-remediation.tfvars file (Used for remediation i.e. to restrict the access of instance to internet)
```
  project = "project_id"
  region = "region"
  password = "password"
  cidr-name = "opcito-office"
  cidr ="1.1.1.1/32"
```

## Remediation Steps:
We need to use variables-remediation.tfvars and main.tf files for remediation, it will restrict Cloud SQL instance access to opcito office network only:
```
   terraform plan -var-file=variables-remediation.tfvars ==>(Shows which resources will be updated)
   terraform apply -var-file=variables-remediation.tfvars ==>(Updates resources)
```

## Steps to destroy the Cloud SQL setup:
```
   terraform plan -destroy
   terraform apply -destroy
```