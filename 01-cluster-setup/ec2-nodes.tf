resource "aws_instance" "control_plane" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3a.small"
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  private_ip                  = local.control_plane_ip

  user_data = base64encode((templatefile("./01-init.sh", {
    hostname           = "control-plane"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
  })))
  user_data_replace_on_change = true


  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.control_plane.id]
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "control-plane"
  }
}

resource "aws_instance" "worker1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3a.medium"
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  private_ip                  = local.worker1_ip
  user_data = base64encode((templatefile("./01-init.sh", {
    hostname           = "worker1"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
  })))
  user_data_replace_on_change = true


  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.workers.id]
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "worker1"
  }
}

resource "aws_instance" "worker2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3a.medium"
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  private_ip                  = local.worker2_ip
  user_data = base64encode((templatefile("./01-init.sh", {
    hostname           = "worker2"
    kubernetes_version = local.kubernetes_version
    control_plane_ip   = local.control_plane_ip
    worker1_ip         = local.worker1_ip
    worker2_ip         = local.worker2_ip
  })))
  user_data_replace_on_change = true
  subnet_id                   = module.vpc.public_subnets[0]
  security_groups             = [aws_security_group.workers.id]

  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "worker2"
  }
}
