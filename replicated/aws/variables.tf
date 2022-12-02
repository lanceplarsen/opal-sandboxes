variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "vpc_name" {
  default     = "opal-vpc"
  description = "VPC name"
}

variable "cluster_name" {
  default     = "opal-cluster"
  description = "Cluster name"
}

variable "db_name" {
  default     = "opal"
  description = "DB name"
}
