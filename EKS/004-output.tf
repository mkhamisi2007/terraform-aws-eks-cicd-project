
# ----------------------------EKS------------------------------------------
output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.eks_cluster.name
}
#----------------------------OIDC------------------------------------------
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer_url" {
  value = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

#----------------------------EFS File System ID -----------------------------
output "efs_file_system_id" {
  description = "EFS File System ID"
  value       = try(aws_efs_file_system.efs_file_system[0].id, null)
}
#--------------------------VPC--------------------------------------------
output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}
output "private_subnet_ids" {
  description = "private subnets id"
  value       = module.vpc.private_subnets
}
output "eks_cluster_security_group_id" {
  description = "EKS cluster security group id"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}
