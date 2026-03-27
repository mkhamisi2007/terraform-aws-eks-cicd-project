data "aws_iam_policy_document" "cw_observability_assume_role" {
  count = var.enable_monitoring ? 1 : 0
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cw_observability_role" {
  count              = var.enable_monitoring ? 1 : 0
  name               = "${aws_eks_cluster.eks_cluster.name}-cw-observability-role"
  assume_role_policy = data.aws_iam_policy_document.cw_observability_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "cw_observability_policy" {
  count      = var.enable_monitoring ? 1 : 0
  role       = aws_iam_role.cw_observability_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_eks_addon" "cloudwatch_observability" {
  count        = var.enable_monitoring ? 1 : 0
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "amazon-cloudwatch-observability"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.cw_observability_policy,
    time_sleep.wait_for_eks_access
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  count        = var.enable_monitoring ? 1 : 0
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    time_sleep.wait_for_eks_access
  ]
}

resource "aws_eks_pod_identity_association" "cw_agent" {
  count           = var.enable_monitoring ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_cluster.name
  namespace       = "amazon-cloudwatch"
  service_account = "cloudwatch-agent"
  role_arn        = aws_iam_role.cw_observability_role[0].arn
  depends_on = [
    aws_eks_addon.cloudwatch_observability,
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.cw_observability_policy
  ]
}
