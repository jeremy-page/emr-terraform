resource "aws_security_group" "emr_master_additional" {
  name        = "emr-master-${var.project_name}-${var.environment}"
  description = "emr-master-${var.project_name}-${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.252.0.0/16", "10.232.32.0/19", "10.251.0.0/16"]
    description = "vpn"
  }

  tags = {
    Name        = "emr-master-${var.project_name}-${var.environment}"
    project     = var.project_name
    environment = var.environment
  }
}

###############
### worker ###
###############

resource "aws_security_group" "emr_worker_additional" {
  name        = "emr-worker-${var.project_name}-${var.environment}"
  description = "emr-worker-${var.project_name}-${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.252.0.0/16", "10.232.32.0/19", "10.251.0.0/16"]
    description = "CMS VPN access"
  }

  tags = {
    Name        = "emr-worker-${var.project_name}-${var.environment}"
    project     = var.project_name
    environment = var.environment
  }
}
