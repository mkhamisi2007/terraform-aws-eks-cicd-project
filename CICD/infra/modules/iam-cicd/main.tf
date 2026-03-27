data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.name_prefix}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    actions = [
      "logs:*",
      "s3:*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "codebuild:*",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchImportUpstreamImage",
      "ecr:CreateRepository",
      "ecr:DescribeRepositories"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.name_prefix}-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.name_prefix}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    actions = [
      "s3:*",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "sns:Publish",
      "eks:DescribeCluster",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeRouteTables",
      "ec2:DescribeAvailabilityZones",
      "iam:PassRole",
      "codestar-connections:UseConnection",
      "codeconnections:UseConnection"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/codepipeline/project-cicd-pipeline",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/codepipeline/project-cicd-pipeline:*"
    ]
  }
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.name_prefix}-codepipeline-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
