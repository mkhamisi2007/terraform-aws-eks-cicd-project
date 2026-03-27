data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mohammad-khamisi-us-bucket"
    key    = "Terraform/eks/terraform.tfstate"
    region = "us-east-1"
  }
}
