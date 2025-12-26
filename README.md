#  Production-Grade deployment of Uptime-Kuma on AWS ECS Fargate

High-availability deployment of Uptime Kuma using ECS Fargate and RDS Multi-AZ (Primary & Standby). The infrastructure is managed with Terraform and GitHub Actions CI/CD.

---

**Documentation:** [Architecture Decisions](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Design_decisions.md) | [Cost Analysis]() | [Future Improvements](https://github.com/RamlaBurhan/Uptime_Kuma_ECS_Project/blob/main/docs/Future_improvements.md)


---
## Live deployment

[View Live Status Page](https://www.rb-monitoring.com/status/services-health)

*Real-time monitoring of rb-monitoring.com: DNS, ALB, ECS, and RDS availability*

**Active Monitors:**
- HTTP GET requests: Full user journey (DNS → ALB → ECS containers)
- DNS-only validation: Route53 record resolution
- TCP connectivity: RDS MariaDB on port 3306
- Response time tracking with 90-day uptime history

---

## Demo

**Demo Walkthrough:** [Watch on Loom](https://www.loom.com/share/c2b4e52a6f7344f6983eccd27522c598)

----

## Architecture Diagram

<img width="1131" height="1370" alt="ECS Project- 3-tier architecture drawio (2)" src="https://github.com/user-attachments/assets/2436c618-be27-4506-a2fb-6dede1db4166" />

----

## What This Project Demonstrates
|--------|----------------|
| **Infrastructure as Code** | Modular Terraform with remote state (S3 + DynamoDB locking), reusable modules for VPC/ECR/ECS/RDS/IAM/ALB/ACM/ROUTE53 |
| **Container Orchestration** | health check integration, auto-scaling policies,  |
| **Database Management** | RDS MariaDB Multi-AZ with automated backups, encryption at rest (KMS) |
| **Networking & Security** | Multi-tier VPC, least-privilege security groups, TLS termination, 
| **CI/CD** | GitHub Actions for infrastructure changes, security scanning (Trivy),OIDC authentication, PR-based approvals |
| **High Availability** | Multi-AZ deployment across compute/database layers, auto-scaling (CPU/memory thresholds) |
| **Observability** | CloudWatch Logs with retention policies, custom metrics, |

---

## Project Structure

```
.
├── .github/
│   └── workflows/
│       ├── apply.yml              
│       ├── destroy.yml            
│       ├── docker.yml             
│       └── plan.yml               
├── app/
│   ├── docker-compose.yml         
│   └── Dockerfile                 
├── docs/
│   ├── Cost_analysiss.md      
│   ├── Design_decisions.md        
│   ├── Future_improvements.md     
│   └── Self-study.md              
├── terraform/
│   ├── modules/
│   │   ├── acm/                   
│   │   ├── alb/                   
│   │   ├── ecr/                   
│   │   ├── ecs/                   
│   │   ├── ecs-autoscaling/       
│   │   ├── iam/                   
│   │   ├── rds/                   
│   │   ├── route53/               
│   │   ├── sg/                    
│   │   └── vpc/                   
│   ├── backend.tf                 
│   ├── local.tf                   
│   ├── main.tf                    
│   ├── output.tf                  
│   ├── provider.tf                
│   ├── variable.tf                
│   └── tfvars_example.md          
├── .gitignore                     
├── .pre-commit-config.yaml        
└── README.md                      
```

---

## Prerequisites

**Tools:** 
- Terraform >= 1.14.2
- Docker Engine >= 28.3.2
- AWS CLI v2 with configured credentials
- pre-commit >= 4.5.1

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

3. **To build and start containersn**
```bash
   docker compose build
   docker compose up -d
```

4. **To access the application:**  
   Open http://localhost:3001

5. **To stop:**
```bash
   docker-compose down
```

## AWS Deployment

1. **Configure backend**

   -  Create backend.tf with your S3 bucket details manually
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

4. **Deploy Infrastructure:**
```bash
   # Create feature branch
   git checkout -b feature/initial-deployment
   git add terraform/
   git commit -m "Initial infrastructure deployment"
   git push origin feature/initial-deployment
```
   
   **Workflow:**
   1. Open pull request on GitHub
   2. Review `terraform plan` output.
   3. Merge PR to `main` branch
   4. `terraform apply` runs automatically on merge
 
---

## CI/CD Pipelines

| Workflow | Trigger | Actions |
|----------|---------|---------|
| Docker Build | App/Dockerfile changes | Build → Trivy scan → Push to ECR |
| Terraform Plan | Pull Request |  Plan |
| Terraform Apply | Merge to main | Apply changes automatically |
| Terraform Destroy | Manual dispatch | Destroy with confirmation |

**Security:** OIDC authentication and Trivy vulnerability scanning
