output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_region" {
  description = "EKS cluster region"
  value       = var.region
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.opal.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.opal.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.opal.username
}

output "rds_password" {
  description = "RDS instance root username"
  value       = random_password.password.result
  sensitive   = true
}
