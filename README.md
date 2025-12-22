# Uptime_Kuma_ECS_Project

This project showcases a production-grade deployment of a self-hosted monitoring tool (Uptime Kuma) using ECS Fargate, RDS Multi-AZ, and EFS. The infrastructure is managed through modular Terraform and GitHub Actions CI/CD.

## Table of contents





## Demo

Project management
<img width="559" height="383" alt="Screenshot 2025-12-22 at 08 02 33" src="https://github.com/user-attachments/assets/eeba51b8-942c-4b29-93be-cc27a727663c" />


## Design and tradeoff



## Architecture diagram

<img width="565" height="370" alt="ECS Project- 3-tier architecture drawio (1)" src="https://github.com/user-attachments/assets/137a48c7-18ac-4588-9a0f-a59f2373342db" />



## Project structure



# Prerequisites

**Tools:** Terraform ≥1.6, Docker ≥20.10, AWS CLI, pre-commit ≥3.0

**AWS:** Administrative access, Route53 hosted zone, domain for ACM

---
## Local Development

1. **Clone repository**
```bash
   git clone <repo-url>
   cd app
```

2. **Install pre-commit hooks**
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
```bash
   terraform {
     backend "s3" {
       bucket = "your-terraform-state-bucket"
       key    = "uptime-kuma/terraform.tfstate"
       region = "us-east-1"
     }
   }
```

2. **Set infrastructure variables**
 - Edit terraform.tfvars with your values.
```bash
   cp terraform.tfvars.example terraform.tfvars
  
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
| Terraform Apply | Merge to `main` | Apply changes automatically |
| Terraform Destroy | Manual dispatch | Destroy with confirmation |

**Security:** OIDC authentication, Trivy vulnerability scanning, tfsec IaC analysis

---

Successful pipeline
