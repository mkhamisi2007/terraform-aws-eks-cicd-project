resource "aws_eks_access_entry" "codepipeline" {
  cluster_name  = var.eks_cluster_name
  principal_arn = module.iam_cicd.codepipeline_role_arn
  type          = "STANDARD"
}
resource "aws_eks_access_policy_association" "codepipeline_cluster_admin" {
  cluster_name  = var.eks_cluster_name
  principal_arn = module.iam_cicd.codepipeline_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
