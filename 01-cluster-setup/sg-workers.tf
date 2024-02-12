# Create a security group for the workers
resource "aws_security_group" "workers" {
  vpc_id = module.vpc.vpc_id

  tags = {
    "Name" = "worker"
  }
}

resource "aws_security_group_rule" "workers_internal" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.workers.id
}

resource "aws_security_group_rule" "workers_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "workers_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.workers.id
  cidr_blocks       = ["0.0.0.0/0"]
}
