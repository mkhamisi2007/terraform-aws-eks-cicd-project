resource "aws_s3_bucket" "artifacts" {
  bucket        = var.artifact_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id


  versioning_configuration {
    status = "Enabled"
  }
  /*lifecycle {
    prevent_destroy = true
  }*/
}

resource "aws_codepipeline" "this" {
  name          = var.name
  role_arn      = var.role_arn
  pipeline_type = "V2"

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = var.github_full_repository_id
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build_And_Push"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy_Test"

    action {
      name            = "Deploy_Test_App"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "EKS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName   = var.eks_cluster_name
        Namespace     = var.test_namespace
        ManifestFiles = "output/test/app.yaml"
      }
    }
  }


  stage {
    name = "Approval"

    action {
      name     = "Manual_Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = var.sns_topic_arn
        CustomData      = "Please review the test environment and approve production deployment if everything looks good."
      }
    }
  }

  stage {
    name = "Deploy_Prod"

    action {
      name            = "Deploy_Prod_App"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "EKS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName   = var.eks_cluster_name
        Namespace     = var.prod_namespace
        ManifestFiles = "output/prod/app.yaml"
      }
    }
  }
}
