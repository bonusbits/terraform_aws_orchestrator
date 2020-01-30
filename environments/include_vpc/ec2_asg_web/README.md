## AWS Autoscaling Web Stack
Created complete environment with a autoscaling group for web services in a private network behind an Application Load Balancer in the public network. Also, a bastion host is created in the private network with and load balancer in the public network. Currently uses a hybrid approach. asp_cf uses CloudFormation. Good example for using items that are not yet supported in Terraform.

## Prerequisites
1. SSH Key Setup in AWS

## Resources Created
1. VPC
1. IAM Instance Profiles
1. x2 ALB
1. Bastion Ubuntu 18.04 EC2 Instance
1. Private and Public Subnets
1. Security Groups
1. SNS Topic for ASG
1. Cloudwatch Metrics
1. Autoscaling Group (CloudFormation)
1. Launch Configuration (CloudFormation)

