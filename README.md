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

## 🔐 Key Features

- EKS Cluster with managed access control
- Worker nodes deployed in private subnets
- No NAT Gateway (VPC endpoints used for AWS service access)
- Secure communication using VPC Interface Endpoints
- ALB deployed in public subnet for controlled inbound traffic
- DNS managed via Route 53
- Public cluster endpoint enabled for CI/CD deployment integration

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
- EBS CSI Driver
- EFS CSI Driver

> ⚙️ All add-ons are configurable via variables.  
> You can enable or disable each component from the `terraform.tfvars` file by setting its corresponding flag to `true` or `false`.
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

---
## 🚀 CI/CD Pipeline (Part 2)

This section describes the automated CI/CD pipeline used to build, validate, and deploy applications to the EKS cluster.

### 📐 Pipeline Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/1e8bf587-359e-4a30-bdd0-6936fd38ffac" />

---

### 🔄 Workflow Overview

The pipeline is implemented using **AWS CodePipeline** and follows these steps:

1. **Source (GitHub)**
   - The pipeline is triggered automatically on code changes (push/merge).

2. **Build (AWS CodeBuild)**
   - Docker image is built from the application source code
   - Image is tagged using commit hash
   - Image is pushed to **Amazon ECR**

3. **Deploy to Test Environment**
   - Kubernetes manifests are dynamically generated
   - Application is deployed to EKS (test environment)
   - Exposed via:
     - **ALB**
     - **Route 53 DNS** → `test.m-khamisi.com`

4. **Manual Approval**
   - A notification is sent via **Amazon SNS**
   - The system administrator reviews the test environment
   - Manual approval is required to continue

5. **Deploy to Production**
   - Application is deployed to production environment in EKS
   - Exposed via:
     - **ALB**
     - **Route 53 DNS** → `app.m-khamisi.com`
   - **Horizontal Pod Autoscaler (HPA)** is enabled for scaling

<img width="1351" height="450" alt="image" src="https://github.com/user-attachments/assets/6f8e6df7-8e3e-4a72-bef4-0cf4e4a76026" />

---

### 📦 Key Features

- Fully automated Docker build & push to ECR
- Dynamic Kubernetes manifest generation using templates
- Separate **test** and **production** environments
- DNS-based environment access (test & prod)
- Manual approval gate before production deployment
- SNS notification integration for operational control
- Production-ready deployment with ALB + HPA

---

### 🧠 Design Highlights

- Clear separation between test and production environments  
- Safe deployment strategy with manual validation  
- Infrastructure and deployment fully automated via AWS services  
- Scalable and production-ready CI/CD workflow  

## 📊 Monitoring & Logging

The platform integrates **Amazon CloudWatch Container Insights** to provide full observability of the EKS cluster.

---

### 📈 Metrics (CloudWatch Container Insights)

- Metrics are collected using **CloudWatch Container Insights**
- Provides real-time visibility into:
  - CPU and memory utilization
  - Pod and node status
  - API server performance
- Used for monitoring cluster health and performance

📸 Example:

<img width="1263" height="583" alt="image" src="https://github.com/user-attachments/assets/0f779b75-e7d5-42af-9ae7-bcc2a15edcc2" />

---

### 📝 Logs (CloudWatch Logs)

- All cluster and application logs are centralized in **Amazon CloudWatch Logs**
- Includes multiple log streams:
  - `/aws/containerinsights/<cluster>/application`
  - `/aws/containerinsights/<cluster>/host`
  - `/aws/containerinsights/<cluster>/dataplane`
  - `/aws/containerinsights/<cluster>/performance`
  - `/aws/eks/<cluster>/cluster`
- Enables efficient debugging and operational monitoring

📸 Example:

<img width="1287" height="523" alt="image" src="https://github.com/user-attachments/assets/df962a16-8722-4cda-a98d-d9c54667db44" />

---

### 🎯 Key Benefits

- Centralized monitoring and logging using AWS native services  
- Deep visibility into Kubernetes workloads and infrastructure  
- Faster troubleshooting with structured log streams  
- Production-ready observability using CloudWatch  









