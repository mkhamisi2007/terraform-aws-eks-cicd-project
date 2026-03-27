#-----------------------------------VPC---------------------------------------------------------
aws_region             = "us-east-1"
vpc_name               = "myvpc"
vpc_cidr_block         = "10.0.0.0/16"
vpc_public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_enable_nat_gateway = true
vpc_single_nat_gateway = true
#-----------------------------------docker-------------------------------------------------------
dockerhub_username = "mkhamisi2007"
dockerhub_token    = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#-----------------------------------EKS----------------------------------------------------------
cluster_name                         = "my_eks_cluster"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
eks_cluster_version                  = "1.35"
cluster_endpoint_private_access      = true
cluster_endpoint_public_access       = true # true at creation and after make it false
# ⚠️ NOTE:
# It is recommended to enable public access to the EKS API endpoint only during the initial provisioning phase.
# This allows Terraform to communicate with the cluster and create all required resources.
#
# After the full infrastructure (including Kubernetes resources) is deployed,
# you should disable public access and rely only on private connectivity for security.
#
# Alternative approach:
# You can run Terraform from a machine connected to the VPC (e.g., via AWS Client VPN),
# but in that case you may face challenges with pulling container images unless proper endpoints are configured.
#
# Recommended approach: Enable public access temporarily, then disable it after deployment.
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
#---------------------------------enable feacure for install on EKS------------------------------
enable_load_balancer        = true
enable_external_dns         = true
enable_cluster_autoscalling = true
enable_metrics_server       = true
enable_efs_driver           = false
enable_ebs_driver           = false
enable_monitoring           = true
enable_core_vpc_endpoints   = true
#----------------------nodes scaling config---------------------------
node_desired_size = 1
node_max_size     = 3
node_min_size     = 1
