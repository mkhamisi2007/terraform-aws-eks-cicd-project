# Resource: Helm Release 
resource "helm_release" "cluster_autoscaler_release" {
  depends_on = [aws_iam_role.cluster_autoscaler_iam_role, time_sleep.wait_for_eks_access]
  count      = var.enable_cluster_autoscalling ? 1 : 0
  name       = "ca"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = "kube-system"

  set = [
    {
      name  = "image.repository"
      value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/autoscaling/cluster-autoscaler"
    },
    {
      name  = "image.tag"
      value = "v1.32.7"
    },
    {
      name  = "cloudProvider"
      value = "aws"
    },
    {
      name  = "autoDiscovery.clusterName"
      value = aws_eks_cluster.eks_cluster.name
    },
    {
      name  = "awsRegion"
      value = var.aws_region
    },
    {
      name  = "rbac.serviceAccount.create"
      value = "true"
    },
    {
      name  = "rbac.serviceAccount.name"
      value = "cluster-autoscaler" # refer to ServiceAccount in file 201 line 49
    },
    {
      name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.cluster_autoscaler_iam_role[0].arn
    }
    # Additional Arguments (Optional) - To Test How to pass Extra Args for Cluster Autoscaler
    # {
    #  name = "extraArgs.scan-interval"
    #  value = "20s"
    #}    
  ]
}
