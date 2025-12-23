<center>

# Infrastructure Architecture Design: Decisions, Trade-offs and Cost Optimisation

</center>


## Table of Contents
[1. Introduction](#introduction) \
   1.1. [Current State](#current-state) \
   1.2. [Future State](#future-state) \
   1.3. [Benefits of Isolated Infrastructure](#benefits-of-isolated-infrastructure) 

[2. Architecture Design: Decisions & Trade-offs](#architecture-design-decisions-trade-offs) \
   [2.1. [Network Isolation](#network-isolation) \
   [2.2. [Container Optimisation](#container-optimisation) \
   [2.3. [Credential Security: OIDC for GitHub Actions](#credential-security-oidc-for-github-actions) \
   [2.4. [ECS Auto-Scaling Strategy](#ecs-auto-scaling-strategy) \
   [2.5. [Terraform Implementation](#terraform-implementation) 

[3. Infrastructure Cost Optimisation](#infrastructure-cost-optimisation) \
   [3.1. NAT Gateway Strategy](#nat-gateway-strategy) \
   [3.2. RDS Multi-AZ](#RDS-Multi-AZ) \
   [3.3. Secrets Manager: Store Only Password](#secrets-manager-store-only-password) \
   [3.4. Log Retention: Aligning Policy with Needs](#log-retention-aligning-policy-with-needs) 

[4. Architecture Key Components](#architecture-key-components) \
   [4.1. Docker](#docker) \
   [4.2. Terraform (Infrastructure as Code)](#terraform-infrastructure-as-code) \
   [4.3. CI/CD (GitHub Actions)](#cicd-github-actions) 



## 1. Introduction

In this document, I present the key architectural decisions and trade-offs I've made in designing my infrastructure, providing a clear justification for my approach.

### 1.1. Current State
- Single environment with feature toggles
- Variables control high availability settings

### 1.2. Future State
- Three separate environments with isolated infrastructure

### 1.3. Benefits of Isolated Infrastructure
- Enhanced security
- Improved stability
- Better resource management
- Simplified maintenance

---

**Note: This documentation is a justification of my approach. There's room for future improvements.**

## 2. Architecture Design: Decisions & Trade-offs

### 2.1. Network Isolation

**Three-tier VPC:**
- Public Subnet (ALB) → Private Subnet (ECS) → Private Subnet (RDS)
- Security groups enforce unidirectional traffic: Internet → ALB → ECS → RDS. 

No direct internet to compute or data layers.

---

### 2.2. Container Optimisation

**Decision:** Implement multi-stage Docker builds.

**Result:**
- Image size reduced from 1.2GB to 127MB (80% reduction)
- Reduces the attack surface
- Faster builds and deployments

---

### 2.3. Credential Security: OIDC for GitHub Actions

**Decision:** Replace static & long-lived credentials with OIDC temporary tokens.

**Result:**
- Short-lived (1-hour) tokens.
- No long-term credentials stored in GitHub secrets
- Near-zero credential leakage risk

---

### 2.4. ECS Auto-Scaling Strategy

**Configuration:** Scale-out at 70% CPU & Memory, scale-in at 30% CPU & Memory 

**Rationale:** Container cold starts are not instant. The 70% threshold provides headroom whilst new tasks spin up, preventing performance degradation during the provisioning window.

**Note:** These thresholds are baseline values and would be refined based on CloudWatch metrics analysis and observed traffic patterns in production.

---

### 2.5. Terraform Implementation

**Modular Structure:**
- Separate files for VPC, ECS, RDS, and other resources
- Promotes code reusability and maintainability

**Remote State:**
- S3 backend with state locking
- Enables team collaboration and prevents conflicts

**Variables:**
- High availability settings controlled by variables
- Allows for flexibility and customisation based on environment

----

## 3. Infrastructure Cost Optimisation
### 3.1. NAT Gateway Strategy

**Configuration:** Terraform boolean (`enable_nat_gateway_ha`) switches between dual NAT (prod) and single NAT (dev).

**The maths:** 
- Production: 2 NAT Gateways = $65/month + (GB processed × $0.045) → Zero downtime on AZ failure
- Development: 1 NAT Gateway = $32/month + (GB processed × $0.045) → Accept brief outages

**Why:** Dev environment matches prod architecture, but doesn't pay for redundancy during testing. One variable change deploys the same topology to both.

**Annual savings:** You save approximately $400 + (the calculation of gb processed) by not running dual NAT in lower environments.

**AWS Pricing:** [NAT Gateway Calculator](https://aws.amazon.com/vpc/pricing/)

---

### 3.2. RDS Multi-AZ

**Cost:** Approx $29/month (Multi-AZ db.t3.micro) vs Approx $16/month (Single-AZ) - Cost includes instance/storage/backup storage

**Note:** db.t3.micro is used for learning/demonstration. Production workloads would typically use db.t3.medium or larger for adequate performance under load.

**What you get w/RDS multi-az:** Zero data loss, sub-2-minute automatic failover and no manual intervention.

**Decision:** Single-AZ in dev (recreate from backups if needed) and Multi-AZ in prod.

**AWS Pricing:** [Instance Database Pricing](https://instances.vantage.sh/aws/rds/db.t3.micro?currency=USD) \
**AWS Pricing:** [RDS Pricing Calculator](https://aws.amazon.com/rds/pricing/)

---

### 3.3. Secrets Manager: Store only password

**Approach:** RDS password in Secrets Manager ($0.40/month + API calls cost) and everything else as free Terraform environment variables.

**Why:** Secrets Manager charges $0.05 per 10K API calls. Storing 5 values instead of 1 = 5x API costs. Host, port, db name and username aren't secrets; they're configuration that isn't sensitive. Hence, why I decided to use environment variables.

**AWS Pricing:**[AWS Secrets Manager Pricing](https://aws.amazon.com/secrets-manager/pricing/)

---

### 3.4. Log Retention: Aligning policy with needs.

**Development:** 7 days → Sufficient for debugging recent issues
**Production:** 30 days → Meets compliance and troubleshooting requirements

**Rationale:** Retaining logs for 30 days in both environments wastes a significant amount per year. Storing development logs that are rarely accessed would be wasteful.

**Retention Strategy:** Keep necessary logs and delete unnecessary ones. Align retention policies with the specific needs of each environment to balance cost optimisation and operational requirements.

--- 

## 4. Architecture Key Components 
### 4.1. Docker 
**- Non-root user:** For enhanced security \
**- Dockerfile:** Multi-stage Dockerfile to create smaller and more secure images \
**- Health checks:** To ensure containers are running properly

### 4.2. Terraform (Infrastructure as Code) 
**- ECS Fargate:** Serverless container orchestration in private subnets \
**- ECS Scaling:** Target tracking policies on CPU and Memory (70%) \
**- RDS Multi-AZ:** MariaDB with automated backups (RDS snapshots) and KMS encryption \
**- Application Load Balancer:** HTTPS termination with ACM certificates \
**- VPC:** Three-tier architecture (public, private app, private RDS subnets) \
**- NAT Gateways:** High availability outbound connectivity across 2 AZs \
**- Secrets Manager:** Encrypted credential storage with KMS \
**- Route 53:** DNS management with ACM certificate validation \
**- Remote State:** S3 backend with native state locking for team collaboration \
**- Monitoring:** \
    • CloudWatch Logs with retention policies \
    • CloudWatch metrics for ECS, RDS, ALB


### 4.3. CI/CD (GitHub Actions) 
**- Docker workflow:** Build, scan with Trivy, push to ECR on Dockerfile or App changes \
**- Terraform Plan:** Runs on pull requests \
**- Terraform Apply:** Automated deployment on merge to main \
**- Terraform Destroy:** Manual workflow with confirmation to prevent accidents \
**- tfsec:** Security scanning for Terraform code vulnerabilities \
**- OIDC:** AWS keys stored in OIDC for credential protection
