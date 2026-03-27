
resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  count      = var.enable_load_balancer ? 1 : 0
  depends_on = [helm_release.loadbalancer_controller]

  metadata {
    name = "my-aws-ingress-class"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }
  spec {
    controller = "ingress.k8s.aws/alb"
  }
}
