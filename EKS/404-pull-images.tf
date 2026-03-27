resource "null_resource" "pull_images" {
  depends_on = [
    aws_ecr_pull_through_cache_rule.k8s
  ]
  triggers = {
    account_id = data.aws_caller_identity.current.account_id
    region     = var.aws_region
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  }

  provisioner "local-exec" {
    command = "docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/external-dns/external-dns:v0.20.0"

  }
  provisioner "local-exec" {
    command = "docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/autoscaling/cluster-autoscaler:v1.32.7"
  }
  provisioner "local-exec" {
    command = "docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/k8s/metrics-server/metrics-server:v0.8.0"
  }
  provisioner "local-exec" {
    command = "docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/docker-hub/library/nginx:stable-alpine"
  }

  # ----- destroy repo----------------
  provisioner "local-exec" {
    when    = destroy
    command = "aws ecr delete-repository --region ${self.triggers.region} --repository-name k8s/external-dns/external-dns --force"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws ecr delete-repository --region ${self.triggers.region} --repository-name k8s/autoscaling/cluster-autoscaler --force"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws ecr delete-repository --region ${self.triggers.region} --repository-name k8s/metrics-server/metrics-server --force"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws ecr delete-repository --region ${self.triggers.region} --repository-name docker-hub/library/nginx --force"
  }

}

