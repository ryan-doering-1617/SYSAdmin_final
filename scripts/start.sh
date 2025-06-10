#!/bin/bash

KEY_NAME="minecraft_key.pem"
KEY_PATH="./terraform/${KEY_NAME}"
PUB_KEY_PATH="${KEY_PATH}.pub"

# Optional: Prompt for AWS credentials
read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -s -p "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo
read -s -p "Enter your AWS Session Token: " AWS_SESSION_TOKEN
echo

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

# Generate SSH keypair before Terraform runs
if [[ ! -f "$KEY_PATH" ]]; then
  echo "[*] Generating SSH keypair..."
  ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
else
  echo "[*] Reusing existing SSH keypair at $KEY_PATH"
fi

# Run Terraform
echo "[*] Running Terraform..."
cd terraform
terraform init
terraform apply -auto-approve
cd ..

# Extract public IP
IP=$(cd terraform && terraform output -raw public_ip)
if [[ -z "$IP" ]]; then
  echo "[!] ERROR: No public IP found from Terraform. Aborting."
  exit 1
fi

# Ensure correct permissions on key
chmod 400 "$KEY_PATH"

# Run Ansible
echo "[*] Running Ansible..."
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "$IP," ansible/playbook.yml --private-key "$KEY_PATH" -u ubuntu

# Verify with Nmap
echo "[*] Minecraft server should be running at $IP:25565"
nmap -sV -Pn -p T:25565 "$IP"