# Resource: Helm Release 
resource "helm_release" "external_dns" {
  count = var.enable_external_dns ? 1 : 0
  depends_on = [
    aws_iam_role.externaldns_iam_role,
    time_sleep.wait_for_eks_access,
    aws_ecr_pull_through_cache_rule.k8s
  ]


  name = "external-dns"

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  #namespace = "default" #---> 301 line 48 => we can install it in kube-system namespace and its a best practice one
  namespace = "kube-system"
  set = [
    {
      name = "image.repository"
      #value = "k8s.gcr.io/external-dns/external-dns"
      value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/external-dns/external-dns"
    },
    {
      name  = "image.tag"
      value = "v0.20.0"
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "external-dns" #---> 301 line 48
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.externaldns_iam_role[0].arn
    },
    {
      name  = "provider" # Default is aws (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
      value = "aws"
    },
    {
      name  = "policy" # Default is "upsert-only" which means DNS records will not get deleted even equivalent Ingress resources are deleted (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
      value = "sync"   # "sync" will ensure that when ingress resource is deleted, equivalent DNS record in Route53 will get deleted
    }
  ]

}
