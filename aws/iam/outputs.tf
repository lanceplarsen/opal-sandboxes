#eks
output "eks_cluster_admin" {
  value = aws_iam_role.eks_cluster_admin
}

output "eks_cluster_viewer" {
  value = aws_iam_role.eks_cluster_viewer
}

#developers
output "developer_frontend" {
  value = aws_iam_role.dev_team_frontend
}

output "developer_backend" {
  value = aws_iam_role.dev_team_backend
}

output "developer_payments" {
  value = aws_iam_role.dev_team_payments
}
