variable "name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "github_connection_arn" {
  type = string
}

variable "github_full_repository_id" {
  type = string
}

variable "github_branch" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "test_namespace" {
  type = string
}

variable "prod_namespace" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}
