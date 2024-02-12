# Create a security group for the control plane
resource "aws_security_group" "control_plane" {
  vpc_id = module.vpc.vpc_id

  tags = {
    "Name" = "control-plane"
  }
}

resource "aws_security_group_rule" "control_plane_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "control_plane_internal" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "control_plane_worker" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.workers.id
}

resource "aws_security_group_rule" "control_plane_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.control_plane.id
  cidr_blocks       = ["0.0.0.0/0"]
}
