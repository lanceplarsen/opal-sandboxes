output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.product-db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.product-db.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.product-db.username
  sensitive   = true
}

output "rds_password" {
  description = "RDS instance root username"
  value       = random_password.password.result
  sensitive   = true
}
