variable "name" {
  type = string
}

variable "service_role_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecr_repository_uri" {
  type = string
}

variable "buildspec" {
  type = string
}

variable "app_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "test_namespace" {
  type = string
}

variable "prod_namespace" {
  type = string
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
