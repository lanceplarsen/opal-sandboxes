output "region" {
  description = "AWS region"
  value       = var.region
}

output "ssh_key_name" {
  value = aws_key_pair.sandbox.key_name
}

output "vpc" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
