# Minecraft Server Deployment on AWS

## Project Overview

This project automates the deployment of a Minecraft server using **Terraform** and **Ansible**, running inside a **Docker container** on an EC2 instance. It provisions infrastructure, installs dependencies, and launches the game server — all without logging into the AWS Management Console.

---

## Requirements

### Software (Local Machine or VM)
| Tool        | Minimum Version | Install Link |
|-------------|------------------|--------------|
| Terraform   | v1.6+            | [Download](https://developer.hashicorp.com/terraform/downloads) |
| Ansible     | v2.15+           | [Install](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) |
| AWS CLI     | v2+              | [Install](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| nmap        | Any              | [Install](https://nmap.org/download.html) |
| Bash shell  | Any              | Works on macOS, Git Bash (Windows), WSL, Linux |

### Credentials

You'll need an AWS credential block with:
- `aws_access_key_id`
- `aws_secret_access_key`
- `aws_session_token`

These are prompted for interactively and **exported temporarily** for Terraform/Ansible use.

---

## How It Works

The system uses the following stages:

1. **Credential Setup** — User is prompted for AWS credentials at runtime.
2. **SSH Key Generation** — A 4096-bit RSA keypair is generated if not already present.
3. **Terraform Provisioning** — Provisions an EC2 instance and security group.
4. **Ansible Configuration** — Installs Docker, pulls the Minecraft image, and runs the server.
5. **Connectivity Check** — Verifies port `25565` is open via `nmap`.

---

## How to Run (Local or VM)

1. **Clone the repository:**
```bash
git clone https://github.com/ryan-doering-1617/SYSAdmin_final
cd SYSAdmin_final
```

2. **Make sure scripts are executable:**
```bash
chmod +x scripts/start.sh
```

3. **Start the deployment:**
```bash
./scripts/start.sh
```

You’ll be prompted for your AWS credentials. The script will:
- Generate an SSH key (`minecraft_key.pem`)
- Save the public key (`minecraft_key.pem.pub`)
- Run `terraform apply` to provision EC2 + Security Group
- Use Ansible to install Docker + start the Minecraft container
- Use `nmap` to scan the Minecraft port

---

## How to Join the Server

After deployment:

1. Note the `public_ip` printed by the script.
2. Use `nmap` to check:
```bash
nmap -sV -Pn -p T:25565 <public_ip>
```
3. Launch Minecraft (Java Edition)
4. Go to **Multiplayer > Direct Connect**
5. Enter the server IP and join!

---

## Cleanup

To avoid AWS charges:
```bash
chmod +x ./scripts/destroy.sh
./scripts/destroy.sh
```
You’ll be prompted for your AWS credentials. The script will destroy your instance.
---

##  Resources & References

- [itzg/minecraft-server (Docker Hub)](https://hub.docker.com/r/itzg/minecraft-server)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/)
- [GitHub Markdown Syntax Guide](https://docs.github.com/en/get-started/writing-on-github)

---