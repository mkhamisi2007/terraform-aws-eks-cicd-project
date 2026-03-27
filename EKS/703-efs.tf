# Resource: Security Group - Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System
resource "aws_security_group" "efs_allow_access" {
  count       = var.enable_efs_driver ? 1 : 0
  name        = "efs-allow-nfs-from-eks-vpc"
  description = "Allow Inbound NFS Traffic from VPC CIDR"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nfs_from_eks_vpc"
  }
}


# Resource: EFS File System
resource "aws_efs_file_system" "efs_file_system" {
  count          = var.enable_efs_driver ? 1 : 0
  creation_token = "efs-demo"
  tags = {
    Name = "efs-demo"
  }
}

# Resource: EFS Mount Target
resource "aws_efs_mount_target" "efs_mount_target" {

  #for_each = toset(module.vpc.private_subnets)
  #count           = 2
  count           = var.enable_efs_driver ? 2 : 0
  file_system_id  = aws_efs_file_system.efs_file_system[0].id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs_allow_access[0].id]
}
#----------------------------------------------------------dynamic provision---------------------------------------
# Resource: Kubernetes Storage Class - for dynamic provision
resource "kubernetes_storage_class_v1" "efs_sc_dynamic" {
  count = var.enable_efs_driver ? 1 : 0
  //depends_on = [helm_release.efs_csi_driver]
  depends_on = [aws_eks_addon.efs_csi[0]]
  metadata {
    name = "efs-sc-dynamic"
  }
  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs_file_system[0].id
    directoryPerms   = "700"                   # directory permission
    gidRangeStart    = "1000"                  # optional(start group id range)
    gidRangeEnd      = "2000"                  # optional(end group id range)
    basePath         = "/dynamic_provisioning" # optional(path)
  }

  reclaim_policy      = "Delete" #or Retain , "delete" if PVC deleted => Access Point deleted
  volume_binding_mode = "Immediate"
}
#------------------------------------------------static provision-------------------------------------------------
#sample storage class for static provision
resource "kubernetes_storage_class_v1" "efs_sc_static" {
  count = var.enable_efs_driver ? 1 : 0
  //depends_on = [helm_release.efs_csi_driver]
  depends_on = [aws_eks_addon.efs_csi[0]]
  metadata {
    name = "efs-sc-static"
  }
  storage_provisioner = "efs.csi.aws.com"
}
#-----------------------------------------------------------------------------------------------------------------
