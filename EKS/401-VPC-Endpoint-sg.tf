resource "aws_security_group" "vpce_sg" {
  count       = var.enable_core_vpc_endpoints ? 1 : 0
  name        = "${var.cluster_name}-vpce-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-vpce-sg"
  }
}
