# Variables grouped by order of operation and alphabetically

# Common
common = {
  aws_profile         = "example"
  create_vpc          = true
  create_bastion      = true
  create_asg_web      = true
  environment         = "dev"
  name                = "example"
  owner               = "first.last@domain.com"
  project             = "autoscaling-web"
  region              = "us-west-2"
}

# VPC
sg_endpoints = {
  description         = "Endpoint Access for Instances"
  egress_rules        = "all-all"
  ingress_cidr_blocks = "0.0.0.0/0"
  ingress_rule        = "all-all"
  name                = "endpoints"
}
vpc = {
  az                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cidr                = ["10.0.0.0/16"]
  enable_ipv6         = ["false"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# Bastion Instance
alb_bastion = {
  backend_port        = "22"
  backend_protocol    = "TCP"
  lb_port             = "22"
  lb_protocol         = "TCP"
  name                = "bastion"
  s3_acl              = "log-delivery-write"
  s3_versioning       = "true"
}
ec2_bastion = {
  ami                 = ["ami-06d51e91cea0dac8d"] // Ubuntu 18.04 - us-west-2
  count               = [1]
  instance_type       = ["t3.small"]
  key_name            = ["example_dev"]
  monitoring          = [true]
  name                = ["bastion"]
  os_type             = ["ubuntu"]
  public_ip           = [false]
  root_volume_size    = [25]
  second_volume_size  = [25]
  user_data           = ["apt-get update && apt-get -y install python-setuptools awscli curl vim"]
}
iam_bastion = {
  description         = ["IAM Profile Role for Bastion Instance"]
  name                = ["bastion"]
  policy              = ["{\"Version\": \"2012-10-17\", \"Statement\": [{ \"Action\": [\"s3:*\", \"ec2:Describe*\", \"elasticloadbalancing:Describe*\", \"autoscaling:Describe*\", \"cloudwatch:*\", \"logs:*\", \"sns:*\" ], \"Effect\": \"Allow\", \"Resource\": \"*\" } ]}"]
  role_policy         = ["{ \"Version\": \"2012-10-17\", \"Statement\": [{\"Action\": \"sts:AssumeRole\", \"Principal\": {\"Service\": \"ec2.amazonaws.com\"},\"Effect\": \"Allow\",\"Sid\": \"\"}]}"]
}
sg_bastion = {
  description         = ["Bastion EC2 Instance Public Access"]
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  name                = ["bastion"]
}

# Autoscaling Web Frontend
alb_web = {
  backend_port        = "80"
  backend_protocol    = "HTTP"
  http_lb_port        = "80"
  https_lb_port       = "443"
  name                = "web"
}
asg_web = {
  ami                       = "ami-031caa7368014dd9e" // Bitnami Nginx Ubuntu 16.04 - us-west-2
  //ami                = "ami-08d489468314a58df" // Amazon Linux 1 - us-west-2
  //ami                 = "ami-06d51e91cea0dac8d" // Ubuntu 18.04 - us-west-2
  //ami_owner           = "679593333241"
  desired_capacity          = "2"
  health_check_type         = "EC2"
  instance_type             = "t3.small"
  key_name                  = "example_dev"
  max_capacity              = "4"
  min_capacity              = "2"
  name                      = "web"
  health_check_grace_period = "300"
  os_type             = "ubuntu"
}
asg_alarm_up_web = {
  name                    = "web"
  acp_name_suffix         = "scale-up"
  acp_scaling_adjustment  = "1"
  acp_adjustment_type     = "ChangeInCapacity"
  acp_cooldown            = "300"
  cma_description         = "Scale-up if CPU > 60% for 4 minutes"
  cma_name_suffix         = "cpu-high"
  cma_comparison_operator = "GreaterThanOrEqualToThreshold"
  cma_evaluation_periods  = "2"
  cma_metric_name         = "CPUUtilization"
  cma_namespace           = "AWS/EC2"
  cma_period              = "120"
  cma_statistic           = "Average"
  cma_threshold           = "60"
}
asg_alarm_down_web = {
  name                    = "web"
  acp_name_suffix         = "scale-down"
  acp_scaling_adjustment  = "-1"
  acp_adjustment_type     = "ChangeInCapacity"
  acp_cooldown            = "1800"
  cma_description         = "Scale-down if CPU < 30% for 10 minutes"
  cma_name_suffix         = "cpu-low"
  cma_comparison_operator = "LessThanThreshold"
  cma_evaluation_periods  = "2"
  cma_metric_name         = "CPUUtilization"
  cma_namespace           = "AWS/EC2"
  cma_period              = "300"
  cma_statistic           = "Average"
  cma_threshold           = "30"
}
iam_web = {
  description         = ["IAM Profile Role for Web Instance"]
  name                = ["web"]
  policy              = ["{\"Version\": \"2012-10-17\", \"Statement\": [{ \"Action\": [\"s3:*\", \"ec2:Describe*\", \"elasticloadbalancing:Describe*\", \"autoscaling:Describe*\", \"cloudwatch:*\", \"logs:*\", \"sns:*\" ], \"Effect\": \"Allow\", \"Resource\": \"*\" } ]}"]
  role_policy         = ["{ \"Version\": \"2012-10-17\", \"Statement\": [{\"Action\": \"sts:AssumeRole\", \"Principal\": {\"Service\": \"ec2.amazonaws.com\"},\"Effect\": \"Allow\",\"Sid\": \"\"}]}"]
}
sg_web = {
  description         = ["Web EC2 Instance Public Access"]
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp", "http-80-tcp", "https-443-tcp"]
  name                = ["web"]
}
sns_web = {
  topic_name_postfix    = "web-alerts"
}
