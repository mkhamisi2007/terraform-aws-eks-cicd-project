terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
  backend "s3" {
    bucket = "mohammad-khamisi-us-bucket"
    key    = "Terraform/cicd/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "my-test-table-for-terraform"
  }
}

