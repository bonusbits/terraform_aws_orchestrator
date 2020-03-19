locals {
  name = "${replace(var.common.name, "_", "-")}-${element(var.parameters.name, 0)}-${var.common.environment}"
}

module "ec2" {
  # https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.12"

  name                   = local.name
  instance_count         = element(var.parameters.count, 0)

  ami                    = element(var.parameters.ami, 0)
  instance_type          = element(var.parameters.instance_type, 0)
  key_name               = element(var.parameters.key_name, 0)
  monitoring             = element(var.parameters.monitoring, 0)
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = element(var.subnet_ids, 0)
  associate_public_ip_address = element(var.parameters.public_ip, 0)
  iam_instance_profile   = var.iam_instance_profile

  user_data_base64 = base64encode(element(var.parameters.user_data, 0))

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = element(var.parameters.root_volume_size, 0)
    }
  ]

  ebs_block_device = [
    {
      device_name = "/dev/xvdz"
      volume_type = "gp2"
      volume_size = element(var.parameters.second_volume_size, 0)
      delete_on_termination = true
    }
  ]

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}
