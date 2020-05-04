# Terraform   

https://terraform.io/

## Requirement
Terraform version >= 0.12

## Description
This project creates the following:
* VPC
* EKS Cluster
* ALB with default targetgroup
* Create ASG with Launch template
* Configure EKS cluster with SGs, IAM roles, etc.
* Deploy nginx-ingress in EKS cluster using Helm Terraform provider
* Create Route53 Hosted zone
* Deploy a nodejs app in EKS cluster using Helm Terraform provider
* Map ingress name with Route53 Record

The project is using public terraform modules with the custom changes required for the project.

Project includes:
* Terraform modules and definition
* Helm chart of the application. (Docker image is stored in private Dockerhub account with public repository)
* Custom values.yaml for nginx-ingress

## Example Usage
```
cd Terraform
terraform init
terraform plan
terraform apply
```
