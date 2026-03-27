resource "aws_codebuild_project" "this" {
  name          = var.name
  service_role  = var.service_role_arn
  build_timeout = 30

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = var.ecr_repository_uri
    }

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }

    environment_variable {
      name  = "CONTAINER_PORT"
      value = tostring(var.container_port)
    }

    environment_variable {
      name  = "TEST_NAMESPACE"
      value = var.test_namespace
    }

    environment_variable {
      name  = "PROD_NAMESPACE"
      value = var.prod_namespace
    }

    environment_variable {
      name  = "TEST_HOSTNAME"
      value = var.test_hostname
    }

    environment_variable {
      name  = "PROD_HOSTNAME"
      value = var.prod_hostname
    }
    environment_variable {
      name  = "ACM_CERTIFICATE_ARN"
      value = var.acm_certificate_arn
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }
}
