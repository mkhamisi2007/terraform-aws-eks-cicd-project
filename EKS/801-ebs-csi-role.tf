#dowload the EBS CSI driver IAM policy from the official GitHub repository and create an AWS IAM policy resource with it.
data "http" "ebs_csi_iam_policy" {
  count = var.enable_ebs_driver ? 1 : 0
  url   = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
  request_headers = {
    "Accept" = "application/json"
  }
}

resource "aws_iam_policy" "ebs_csi_iam_policy" {
  count       = var.enable_ebs_driver ? 1 : 0
  name        = "ebs-csi-iam-policy"
  description = "IAM policy for EBS CSI driver"
  policy      = data.http.ebs_csi_iam_policy[0].response_body
}

resource "aws_iam_role" "ebs_csi_iam_role" {
  count = var.enable_ebs_driver ? 1 : 0
  name  = "ebs-csi-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attachment" {
  count      = var.enable_ebs_driver ? 1 : 0
  role       = aws_iam_role.ebs_csi_iam_role[0].name
  policy_arn = aws_iam_policy.ebs_csi_iam_policy[0].arn
}
