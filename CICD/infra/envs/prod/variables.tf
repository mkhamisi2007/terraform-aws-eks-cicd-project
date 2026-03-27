variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "github_connection_arn" {
  type = string
}

variable "github_full_repository_id" {
  type        = string
  description = "Example: mkhamisi2007/myapp"
}

variable "github_branch" {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "sns_email" {
  type = string
}

variable "test_namespace" {
  type    = string
  default = "test"
}

variable "prod_namespace" {
  type    = string
  default = "prod"
}

variable "app_name" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "test_hostname" {
  type = string
}

variable "prod_hostname" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}
