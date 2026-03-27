resource "aws_vpc_endpoint" "ecr_api" {
  count               = var.enable_core_vpc_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-ecr-api-vpce"
  }
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  count               = var.enable_core_vpc_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-ecr-dkr-vpce"
  }
}
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_core_vpc_endpoints ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = {
    Name = "${var.cluster_name}-s3-vpce"
  }
}
resource "aws_vpc_endpoint" "sts" {
  count               = var.enable_core_vpc_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-sts-vpce"
  }
}
resource "aws_vpc_endpoint" "eks" {
  count               = var.enable_core_vpc_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.eks"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-eks-vpce"
  }
}
resource "aws_vpc_endpoint" "logs" {
  count               = var.enable_monitoring ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-logs-vpce"
  }
}
resource "aws_vpc_endpoint" "monitoring" {
  count               = var.enable_monitoring ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-monitoring-vpce"
  }
}
resource "aws_vpc_endpoint" "eks_auth" {
  count               = var.enable_monitoring ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.eks-auth"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${aws_eks_cluster.eks_cluster.name}-eks-auth-vpce"
  }
}
resource "aws_vpc_endpoint" "elb" {
  count               = var.enable_load_balancer ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-elb-vpce"
  }
}
resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_cluster_autoscalling ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-ec2-vpce"
  }
}
resource "aws_vpc_endpoint" "autoscaling" {
  count               = var.enable_cluster_autoscalling ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.autoscaling"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-autoscaling-vpce"
  }
}
resource "aws_vpc_endpoint" "efs" {
  count               = var.enable_efs_driver ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.elasticfilesystem"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-efs-vpce"
  }
}
resource "aws_vpc_endpoint" "route53" {
  count               = var.enable_external_dns ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.route53"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpce_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.cluster_name}-route53-vpce"
  }
}

