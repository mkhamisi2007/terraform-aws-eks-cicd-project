# Terraform AWS EKS CI/CD Project

This project is divided into two main parts:

- **EKS Infrastructure (Part 1)** → Provisioning a secure and production-ready Kubernetes cluster on AWS using Terraform  
- **CI/CD Pipeline (Part 2)** → Automating build, test, and deployment processes (coming next)

---

## 🏗️ EKS Infrastructure (Part 1)

This section focuses on building a **fully private and production-grade EKS cluster** using Terraform.

### 📐 Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/f20b243f-6ec2-42c0-937a-0c3c9f00b1eb" />

---

### 🔐 Key Features

- Private EKS Cluster (no public access)
- Worker nodes deployed in private subnets
- No NAT Gateway (fully private architecture)
- Secure communication using VPC Interface Endpoints
- ALB deployed in public subnet for controlled inbound traffic
- DNS managed via Route 53

---

### 🔌 VPC Endpoints (No Internet Access)

All AWS service communications are handled via **VPC Interface Endpoints**, eliminating the need for internet access:

- ECR (image pull)
- CloudWatch (logs & monitoring)
- EKS API
- Route 53
- EFS / EBS
- EC2 / STS / Autoscaling

---

### ⚙️ EKS Add-ons

The cluster includes the following add-ons (installed via Terraform & Helm):

- AWS Load Balancer Controller
- ExternalDNS
- Cluster Autoscaler
- Metrics Server
- CloudWatch logging (FluentBit)

---

### 🌐 Networking Design

- VPC CIDR: `10.0.0.0/16`
- Public Subnet:
  - Application Load Balancer (ALB)
- Private Subnet:
  - EKS Worker Nodes (Private Node Group)

---

### 🚫 Security Design

- No direct internet access from nodes
- No NAT Gateway used
- All outbound traffic routed via VPC Endpoints
- IAM Roles for Service Accounts (IRSA)

## ⚠️ Important Note – EKS API Access

During initial deployment, public access to the EKS API endpoint should be enabled
to allow Terraform to provision all required resources.

After deployment is complete, it is strongly recommended to disable public access
and restrict access to private networking only.

Alternative: You may run Terraform from within the VPC (e.g., via AWS Client VPN),
but additional configuration may be required for container image access.
---




