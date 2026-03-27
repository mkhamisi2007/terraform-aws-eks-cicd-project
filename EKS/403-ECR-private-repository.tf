resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
  numeric = false
}
resource "aws_secretsmanager_secret" "dockerhub" {
  name = "ecr-pullthroughcache/dockerhub-${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret_version" "dockerhub" {
  secret_id = aws_secretsmanager_secret.dockerhub.id

  secret_string = jsonencode({
    username    = var.dockerhub_username
    accessToken = var.dockerhub_token
  })
}

resource "aws_ecr_pull_through_cache_rule" "dockerhub" {
  ecr_repository_prefix = "docker-hub"
  upstream_registry_url = "registry-1.docker.io"
  credential_arn        = aws_secretsmanager_secret.dockerhub.arn
}

resource "aws_ecr_pull_through_cache_rule" "k8s" {
  ecr_repository_prefix = "k8s"
  upstream_registry_url = "registry.k8s.io"
}
resource "aws_ecr_pull_through_cache_rule" "ecr_public" {
  ecr_repository_prefix = "ecr-public"
  upstream_registry_url = "public.ecr.aws"
}

