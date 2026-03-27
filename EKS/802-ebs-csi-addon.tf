resource "aws_eks_addon" "ebs_csi" {
  count                    = var.enable_ebs_driver ? 1 : 0
  cluster_name             = aws_eks_cluster.eks_cluster.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_iam_role[0].arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attachment,
    time_sleep.wait_for_eks_access
  ]
}

