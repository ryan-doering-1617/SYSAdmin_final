#!/bin/bash

# Prompt for AWS credentials
read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -s -p "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo
read -s -p "Enter your AWS Session Token: " AWS_SESSION_TOKEN
echo

# Export credentials
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

# Navigate to Terraform directory and destroy resources
cd terraform || { echo "[!] terraform directory not found"; exit 1; }
terraform init
terraform destroy -auto-approve