data "aws_ami" "amzlinux2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]

}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
data "tls_certificate" "oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
