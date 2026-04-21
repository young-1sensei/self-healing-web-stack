# Automated Control Plane & Self-Healing Web Stack

[![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Config-Ansible-EE0000?logo=ansible)](https://www.ansible.com/)
[![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?logo=amazon-aws)](https://aws.amazon.com/)

This project demonstrates a production-ready, resilient AWS architecture. It features a centralized **Management Control Node** that autonomously discovers and configures a fleet of private web servers using Terraform and Ansible.

## 🏗️ Architecture

The stack is designed with high availability and security in mind:

- **VPC & Networking:** A custom VPC with Public and Private subnets.
- **Control Plane:** A public-facing Control Node pre-configured with the automation engine.
- **Web Tier:** Private web servers managed by an **Auto Scaling Group (ASG)**.
- **Load Balancing:** An **Application Load Balancer (ALB)** to distribute traffic.
- **Connectivity:** A NAT Gateway allows private instances to securely pull updates without being exposed to the internet.

```mermaid
graph TD
    User((User)) --> ALB[Application Load Balancer]
    subgraph Public Subnet
        ALB
        Control[Ansible Control Node]
    end
    subgraph Private Subnet
        Web1[Nginx Web Server 1]
        Web2[Nginx Web Server 2]
    end
    ALB --> Web1
    ALB --> Web2
    Control -.->|SSH & Config| Web1
    Control -.->|SSH & Config| Web2
    Web1 --> NAT[NAT Gateway]
    Web2 --> NAT
```

## 🌟 Key Features & Benefits

| Feature | Benefit |
| :--- | :--- |
| **Self-Healing** | If a web instance fails, the ASG automatically replaces it, and the Control Plane re-configures it instantly. |
| **Security** | Web servers are located in private subnets, only accessible via the ALB or the Control Node. |
| **Scalability** | Easily scale the web tier from 2 to 100+ instances by simply updating a Terraform variable. |
| **Idempotency** | Ansible ensure the "Desired State" is always maintained without redundant operations. |
| **Dynamic Discovery** | Uses the `aws_ec2` plugin to automatically find new servers via AWS tags—no static IP lists needed. |

## 🚀 Getting Started

### Prerequisites
- AWS CLI configured with appropriate permissions.
- Terraform installed locally.
- An SSH Key Pair (`my-anisible-terraform-key.pem`) available in the project root.

### Deployment

1. **Provision Infrastructure:**
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```

2. **Bootstrap the Control Plane:**
   - Transfer your SSH key to the Control Node.
   - The Control Node will automatically install Ansible and Git via its User Data script.

3. **Configure the Web Stack:**
   From the Control Node:
   ```bash
   ansible-playbook site.yml
   ```

## 🛠️ Tech Stack
- **Infrastructure:** Terraform
- **Configuration Management:** Ansible (Dynamic Inventory)
- **Cloud:** AWS (VPC, EC2, ASG, ALB, IAM, NAT GW)
- **OS:** Amazon Linux 2023
- **Web Server:** Nginx
