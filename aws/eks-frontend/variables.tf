variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "cluster_name" {
  default     = "frontend-cluster"
  description = "EKS cluster name"
}

variable "opal_group" {
  default     = ""
  description = "Opal group owner"
}
