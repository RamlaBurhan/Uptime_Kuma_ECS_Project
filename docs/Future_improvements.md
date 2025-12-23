
### Future Improvements
**Security & Automation**
- Create an AWS Lambda to automatically rotate RDS passwords managed by Secrets Manager.

**Database Optimisation**
- Add read replicas for read-heavy monitoring workloads.
- Include blue-green deployments for zero‑downtime during vertical scaling. Look into alternative deployment patterns.

**Infrastructure & Cost**
- Use Terraform workspaces or Terragrunt for multi‑environment isolation.
- Implement VPC endpoints for Secrets Manager, RDS, EFS and CloudWatch (AWS services).

**Observability**
- Incorporate application and business metrics, as well as distributed tracing for ECS tasks.
- Add alerts and dashboards for better visibility.