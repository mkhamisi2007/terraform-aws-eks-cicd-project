variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

locals {
  common_tags = {
    Environment = "Terraform-Project"
  }
}
#------------------- VPC Variables ------------------#
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "myvpc"
}
variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/16"
}
variable "vpc_public_subnets" {
  description = "Public subnets of the VPC"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_private_subnets" {
  description = "Private subnets of the VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  default     = true
}
variable "vpc_single_nat_gateway" {
  description = "Use a single NAT Gateway for the VPC"
  default     = true
}
#------------------- EKS Cluster Variables ------------------#
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eksdemo"
}
variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = "172.20.0.0/16"
}
variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.34"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
#----------------------------dockerhub-------------------------
variable "dockerhub_username" {
  type = string
}
variable "dockerhub_token" {
  type      = string
  sensitive = true
}
#--------------------enable feature of EKS---------------------
variable "enable_load_balancer" {
  type    = bool
  default = true
}
variable "enable_external_dns" {
  type    = bool
  default = true
}
variable "enable_cluster_autoscalling" {
  type    = bool
  default = true
}
variable "enable_metrics_server" {
  type    = bool
  default = true
}
variable "enable_efs_driver" {
  type    = bool
  default = true
}
variable "enable_ebs_driver" {
  type    = bool
  default = true
}
variable "enable_monitoring" {
  type    = bool
  default = true
}
variable "enable_core_vpc_endpoints" {
  type    = bool
  default = true
}

#----------------------scaling config---------------------------
variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}
