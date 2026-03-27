provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "ecr" {
  source = "../../modules/ecr"
  name   = var.ecr_repository_name
  tags   = local.common_tags
}

module "sns" {
  source     = "../../modules/sns"
  topic_name = "${var.project_name}-approval-topic"
  email      = var.sns_email
}

module "iam_cicd" {
  source      = "../../modules/iam-cicd"
  name_prefix = var.project_name
}

module "codebuild" {
  source              = "../../modules/codebuild"
  name                = "${var.project_name}-build"
  service_role_arn    = module.iam_cicd.codebuild_role_arn
  aws_region          = var.aws_region
  ecr_repository_uri  = module.ecr.repository_url
  app_name            = var.app_name
  container_port      = var.container_port
  test_namespace      = var.test_namespace
  prod_namespace      = var.prod_namespace
  test_hostname       = var.test_hostname
  prod_hostname       = var.prod_hostname
  acm_certificate_arn = var.acm_certificate_arn
  buildspec = templatefile("${path.module}/../../templates/buildspec.yml.tftpl", {
    deployment_test_template_b64 = base64encode(file("${path.module}/../../templates/deployment-test.yaml.tftpl"))
    deployment_prod_template_b64 = base64encode(file("${path.module}/../../templates/deployment-prod.yaml.tftpl"))
  })
}

module "codepipeline" {
  source                    = "../../modules/codepipeline"
  name                      = "${var.project_name}-pipeline"
  role_arn                  = module.iam_cicd.codepipeline_role_arn
  artifact_bucket_name      = var.artifact_bucket_name
  github_connection_arn     = var.github_connection_arn
  github_full_repository_id = var.github_full_repository_id
  github_branch             = var.github_branch
  codebuild_project_name    = module.codebuild.project_name
  eks_cluster_name          = var.eks_cluster_name
  test_namespace            = var.test_namespace
  prod_namespace            = var.prod_namespace
  sns_topic_arn             = module.sns.topic_arn

}
