#  Production-Grade deployment of Uptime-Kuma on AWS ECS Fargate

High-availability deployment of Uptime Kuma using ECS Fargate and RDS Multi-AZ (Primary & Standby). The infrastructure is managed with Terraform and GitHub Actions CI/CD.

**Infrastructure Highlights:**
- Modular Terraform design with remote state (S3 + DynamoDB locking)
- Custom domain with TLS termination (Route53 + ACM)
- RDS MariaDB with automated backups (7-day retention) and KMS encryption
- Docker multi-stage builds (89% image size reduction: 1.2GB → 127MB)

---

## Live deployment

[View Live Status Page](https://www.rb-monitoring.com/status/services-health)

**Real-time monitoring of rb-monitoring.com: DNS, ALB, ECS, and RDS availability**

**Active Monitors:**
- HTTP GET requests: Full user journey (DNS → ALB → ECS containers)
- DNS-only validation: Route53 record resolution
- TCP connectivity: RDS MariaDB on port 3306
- Response time tracking with 90-day uptime history

---

## Demo

### **Demo Walkthrough:** [Watch on Loom](https://www.loom.com/share/c2b4e52a6f7344f6983eccd27522c598)

----

## Architecture Diagram

<img width="1131" height="1370" alt="ECS Project- 3-tier architecture drawio (2)" src="https://github.com/user-attachments/assets/2436c618-be27-4506-a2fb-6dede1db4166" />

----

## This Project Demonstrates:

| Domain | Implementation |
|--------|----------------|
| **Infrastructure as Code** | Modular Terraform with remote state (S3 + DynamoDB locking), reusable modules |
| **Container Orchestration** | Health check integration, auto-scaling policies |
| **Database Management** | RDS MariaDB Multi-AZ with automated backups, encryption at rest (KMS) |
| **Networking & Security** | Multi-tier VPC, least-privilege security groups, TLS termination |
| **CI/CD** | GitHub Actions for infrastructure changes, security scanning (Trivy), OIDC authentication, PR-based approvals |
| **High Availability** | Multi-AZ deployment across compute/database layers, auto-scaling (CPU/memory thresholds) |
| **Observability** | CloudWatch Logs with retention policies, Container Insights enabled |

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
├       
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
- pre-commit >= 4.5.1
- Aws account

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

3. **To build and start containers**
```bash
   docker compose build
   docker compose up -d
```

4. **To access the application:**  
```bash
   Open http://localhost:3001
```

5. **To stop container:**
```bash
   docker-compose down
```

## AWS Deployment

1. **Configure backend**
- Go to the terraform directory 
```bash
   cd terraform
 ```
- Create backend.tf with your S3 bucket details manually 

```bash
   terraform {
     backend "s3" {
       bucket = "your-terraform-state-bucket"
       key    = "terraform/terraform.tfstate"
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
- Create feature branch
```bash
   git checkout -b feature/initial-deployment
   git add terraform/
   git commit -m "Initial infrastructure deployment"
   git push origin feature/initial-deployment
```
   
   **Workflow:**
   1. Open pull request on GitHub
   2. Terraform plan runs automatically on pull request
   3. Merge Pull Request to main branch
   4. Terraform apply runs automatically on merge
   
 
---

## CI/CD Pipelines

| Workflow | Trigger | Actions |
|----------|---------|---------|
| Docker Build | App/Dockerfile changes | Build → Trivy scan → Push to ECR |
| Terraform Plan | Pull Request | Validate infrastructure changes |
| Terraform Apply | Merge to main | Apply changes automatically |
| Terraform Destroy | Manual dispatch | Destroy with confirmation |

**Security:** OIDC authentication and Trivy vulnerability scanning

---

## Deployment Verification

### Secure Application Access
<img width="1283" height="646" alt="Screenshot 2025-12-26 at 18 20 21" src="https://github.com/user-attachments/assets/ba80e60f-14af-4c38-b26e-6882f2c840b2" />

---

### Terraform Apply
<img width="528" height="408" alt="TF APPLY" src="https://github.com/user-attachments/assets/33934149-0de3-4265-ba28-074cb08d2833" />

---

### Terraform Destroy
<img width="396" height="345" alt="TF DESTROY" src="https://github.com/user-attachments/assets/a19ca254-e70e-4d2d-ac11-99c2190dc4f9" />

---

### Docker Build and Push to ECR
<img width="496" height="292" alt="DOCKER" src="https://github.com/user-attachments/assets/cb30384c-c879-4141-b793-d960f7f81f7a" />

---

## Future Improvements
**1. Security & Automation**
- Create an AWS Lambda to automatically rotate RDS passwords managed by Secrets Manager.

**2. Database Optimisation**
- Add read replicas for read-heavy monitoring workloads.
- Include blue-green deployments for zero‑downtime during vertical scaling. Look into alternative deployment patterns.

**3. Infrastructure & Cost**
- Use Terraform workspaces or Terragrunt for multi‑environment isolation.
- Implement VPC endpoints for (AWS services).

**4. Observability**
- Incorporate application and business metrics.
- Add alerts and dashboards for better visibility.
