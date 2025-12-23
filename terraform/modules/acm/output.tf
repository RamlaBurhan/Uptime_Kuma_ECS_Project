
output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "domain_name" {
  description = "Domain name the certificate is issued for"
  value       = aws_acm_certificate.this.domain_name
}
