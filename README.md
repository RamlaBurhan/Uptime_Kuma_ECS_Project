# # Production-Grade Monitoring Deployment on AWS ECS Fargate

High-availability deployment of Uptime Kuma using ECS Fargate and RDS Multi-AZ (Primary & Standby). The infrastructure is managed with Terraform and GitHub Actions CI/CD.


### 📊 [View Live Status Page](https://www.rb-monitoring.com/status/services-health)

*Real-time monitoring of DNS, ALB, ECS, and RDS availability*

**Active Monitors:**
- HTTP GET requests: Full user journey (DNS → ALB → ECS containers)
- DNS-only validation: Route53 record resolution
- TCP connectivity: RDS MariaDB on port 3306
- Response time tracking with 90-day uptime history

---

<div align="center">
   
**Documentation:** [Architecture Decisions](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Design_decisions.md) | [Cost Analysis]() | [Future Improvements](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Future_improvements.md)

</div>

## Table of Contents
- [Demo](#demo)
- [Project management](#project-management)
- [Architecture Diagram](#architecture-diagram)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Key Features](#key-features)
- [Local Development](#local-development)
- [AWS Deployment](#aws-deployment)
- [CI/CD Pipelines](#cicd-pipelines)

---

**Live Demo**


<div style="position: relative; padding-bottom: 56.42633228840126%; height: 0;"><iframe src="https://www.loom.com/embed/c2b4e52a6f7344f6983eccd27522c598" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

<div align="center">
   
**This deployment is currently monitoring its own services 24/7:**

</div>

----

## Project management

<img width="1175" height="610" alt="Screenshot 2025-12-22 at 22 52 25" src="https://github.com/user-attachments/assets/234f54ce-5841-47b2-86cf-94946a26d9ef" />


## Architecture Diagram
<img width="1131" height="1370" alt="ECS Project- 3-tier architecture drawio (1)" src="https://github.com/user-attachments/assets/16865c6d-d6fd-4f3a-8aac-6703774689a0" />

## Project Structure

<!-- Add your project structure here -->

---

## Prerequisites

**Tools:** 
- Terraform >= 1.5.0
- Docker Engine >= 20.10
- AWS CLI v2 with configured credentials
- pre-commit >= 3.0.0

---

## Key Features
 **- High Availability:** - Multi-AZ deployment across all layers  
 **- Auto-scaling:** - CPU/Memory-based ECS task scaling  
 **- Encrypted at Rest:** - RDS (KMS), EFS, Secrets Manager  
 **- Encrypted in Transit:** - TLS termination at ALB  
 **- Github Action:** - Infrastructure changes via PR workflow  
 **- Non-root Containers:** - Security-hardened Docker images  
 **- Zero Downtime:** Rolling deployments with health checks 
 **- Logs:** CloudWatch Logs with retention policies  
 **- Metrics:** CloudWatch metrics for ECS, RDS, ALB  
 **- Backups:** Automated RDS snapshots with configurable retention 

---

## Local Development

1. **Clone repository:**
```bash
   git clone <repo-url>
   cd app
```

2. **Install pre-commit hooks locally:**
```bash
   pre-commit install
```

3. **Start application:**
```bash
   docker compose build
   docker compose up -d
```

4. **To access the application:**  
   Open http://localhost:3001

**To stop:**
```bash
docker-compose down
```

## AWS Deployment
**Setup:**

1. **Configure backend**

   -  Create backend.tf with your S3 bucket details
   Go to the terraform directory:
   ```bash
   cd terraform
   ```
```bash
   terraform {
     backend "s3" {
       bucket = "your-terraform-state-bucket"
       key    = "uptime-kuma/terraform.tfstate"
       region = "your-region"
     }
   }
```

2. **Set infrastructure variables**
 - Edit terraform.tfvars with your values.
```bash
   cp tfvars.example terraform.tfvars
```

3. **Configure GitHub OIDC**
   - Create `OIDC IAM role` in AWS.
   - Add role ARN as `ADMIN_ARN` in GitHub repository secrets.

4. **Deploy:**
```bash
   git push origin main
```
 
---

## CI/CD Pipelines

| Workflow | Trigger | Actions |
|----------|---------|---------|
| Docker Build | App/Dockerfile changes | Build → Trivy scan → Push to ECR |
| Terraform Plan | Pull Request | tfsec scan → Plan → Comment PR |
| Terraform Apply | Merge to main | Apply changes automatically |
| Terraform Destroy | Manual dispatch | Destroy with confirmation |

**Security:** OIDC authentication, Trivy vulnerability scanning, tfsec IaC analysis
