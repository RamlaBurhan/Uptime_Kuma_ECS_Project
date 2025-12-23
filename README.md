# Deploying a Self-Hosted Monitoring Tool (Uptime-Kuma) with AWS ECS Fargate, RDS, and EFS

This project showcases a production-grade deployment of a self-hosted monitoring tool (Uptime Kuma) using ECS Fargate, RDS Multi-AZ, and EFS. The infrastructure is managed through modular Terraform and GitHub Actions CI/CD.


## Related Documentations
- For a detailed breakdown of the architecture and tradeoffs, see the [Design Decisions Directory](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Design_decisions.md)
- For planned future iterations and enhancements, please see the [Future Improvements Directory](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Future_improvements.md)


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

## Demo

## Project management

<img width="1175" height="610" alt="Screenshot 2025-12-22 at 22 52 25" src="https://github.com/user-attachments/assets/234f54ce-5841-47b2-86cf-94946a26d9ef" />


## Architecture Diagram
<img width="1131" height="1370" alt="ECS Project- 3-tier architecture drawio (1)" src="https://github.com/user-attachments/assets/16865c6d-d6fd-4f3a-8aac-6703774689a0" />

## Project Structure

<!-- Add your project structure here -->

---

## Prerequisites

**Tools:** Terraform, Docker, pre-commit and AWS access & CLI 

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
   docker-compose up -d
```

4. **To access the application:**  
   Navigate to http://localhost:3001

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
