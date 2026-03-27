# we dont need to install cluster autoscaler for metric server
resource "helm_release" "metrics_server" {

  depends_on = [time_sleep.wait_for_eks_access]
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  namespace = "kube-system"
  set = [
    {
      name  = "image.repository"
      value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/metrics-server/metrics-server"
    },
    {
      name  = "image.tag"
      value = "v0.8.0"
    }
  ]
}
