resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn #--> master role
  version  = var.eks_cluster_version
  vpc_config {
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr #--> cluster service ipv4 cidr
  }
  # control plane logging to send logs to cloudwatch
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP" #--> API or CONFIG_MAP
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_role_policy_attachment
  ]
}
