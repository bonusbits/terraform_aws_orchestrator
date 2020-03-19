data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_availability_zone" "az" {
  count = local.az_count
  name  = data.aws_availability_zones.available.names[count.index]
}

locals {
  aws_region = data.aws_region.current
  aws_region_shortname = var.region_shortname[data.aws_region.current]
  az_count = var.az_count[data.aws_region.current.name]
  vpc_cidr_block = "${var.parameters.subnet_prefix}.${var.parameters.vpc_cidr_block_suffix}"
  name = var.common.name
}

# VPC
resource "aws_vpc" "default" {
  cidr_block              = local.vpc_cidr_block
  enable_dns_support      = true
  enable_dns_hostnames    = true
  tags = {
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Name                  = local.name
    Owner                 = var.common.owner
    Project              = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_vpc_dhcp_options" "default" {
  domain_name             = var.parameters.dhcp_domain_name
  domain_name_servers     = ["AmazonProvidedDNS"]
  tags = {
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Name                  = local.name
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id                  = aws_vpc.default.id
  dhcp_options_id         = aws_vpc_dhcp_options.default.id
}

# SSH Key Pairs
resource "aws_key_pair" "private_frontend_instances" {
  key_name                = "${terraform.workspace}-private-frontend-instances"
  public_key              = file("environments/secrets/${terraform.workspace}/private-frontend-instances.pub")
}
resource "aws_key_pair" "private_backend_instances" {
  key_name                = "${terraform.workspace}-private-backend-instances"
  public_key              = file("environments/secrets/${terraform.workspace}/private-backend-instances.pub")
}
resource "aws_key_pair" "public_instances" {
  key_name                = "${terraform.workspace}-public-instances"
  public_key              = file("environments/secrets/${terraform.workspace}/public-instances.pub")
}

# S3 VPC Endpoint
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}
resource "aws_vpc_endpoint" "s3" {
  vpc_id                  = aws_vpc.default.id
  service_name            = data.aws_vpc_endpoint_service.s3.service_name
  tags = {
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Name                  = local.name
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_vpc_endpoint_route_table_association" "public" {
  route_table_id          = aws_route_table.public.id
  vpc_endpoint_id         = aws_vpc_endpoint.s3.id
}
resource "aws_vpc_endpoint_route_table_association" "private" {
  route_table_id          = aws_route_table.private.id
  vpc_endpoint_id         = aws_vpc_endpoint.s3.id
}

# NAT
resource "aws_eip" "nat" {
  vpc                     = "true"
  tags = {
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Name                  = local.name
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_nat_gateway" "public" {
  allocation_id           = aws_eip.nat.id
  subnet_id               = aws_subnet.public[0].id
  depends_on              = [aws_eip.nat]
  tags = {
    Name                  = local.name
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id                  = aws_vpc.default.id
  tags = {
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Name                  = local.name
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}

# Private Backend
resource "aws_subnet" "private_backend" {
  vpc_id                  = aws_vpc.default.id
  count                   = local.az_count
  cidr_block              = cidrsubnet("${var.parameters.subnet_prefix}.${var.parameters.private_ops_3octet}.0/21", 3, count.index)
  availability_zone       = element(data.aws_availability_zone.az.*.name, count.index)
  tags = {
    Name                  = "${local.name}-private-${element(data.aws_availability_zone.az.*.name_suffix, count.index)}"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table" "private_backend" {
  vpc_id                  = aws_vpc.default.id
  route {
    cidr_block            = "0.0.0.0/0"
    nat_gateway_id        = aws_nat_gateway.public.id
  }
  tags = {
    Name                  = "${local.name}-private-backend"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table_association" "private_backend" {
  count                   = local.az_count
  depends_on              = [aws_subnet.private_backend]
  subnet_id               = element(aws_subnet.private_backend.*.id, count.index)
  route_table_id          = aws_route_table.private.id
}
resource "aws_network_acl" "private_backend" {
  vpc_id                  = aws_vpc.default.id
  subnet_ids = concat(aws_subnet.private_backend.*.id)
  tags = {
    Name                  = "${local.name}-private-backend"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_network_acl_rule" "private_backend_egress_100" {
  network_acl_id          = aws_network_acl.private_backend.id
  rule_number             = 100
  egress                  = true
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private_backend_ingress_100" {
  network_acl_id          = aws_network_acl.private_backend.id
  rule_number             = 100
  egress                  = false
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = local.vpc_cidr_block
}

# Private Frontend
resource "aws_subnet" "private_frontend" {
  vpc_id                  = aws_vpc.default.id
  count                   = local.az_count
  cidr_block              = cidrsubnet("${var.parameters.subnet_prefix}.${var.parameters.dmz_3octet}.0/21", 3, count.index)
  availability_zone       = element(data.aws_availability_zone.az.*.name, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Environment           = var.common.environment
    Module                = "network"
    Name                  = "${local.name}-dmz-${element(data.aws_availability_zone.az.*.name_suffix, count.index)}"
    Orchestrator          = "terraform"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table" "private_frontend" {
  vpc_id                  = aws_vpc.default.id
  route {
    cidr_block            = "0.0.0.0/0"
    nat_gateway_id        = aws_nat_gateway.public.id
  }
  tags = {
    Name                  = "${local.name}-private-frontend"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table_association" "private_frontend" {
  subnet_id               = element(aws_subnet.private_frontend.*.id, local.az_count)
  route_table_id          = aws_route_table.public.id
}
resource "aws_network_acl" "private_frontend" {
  vpc_id                  = aws_vpc.default.id
  subnet_ids              = concat(aws_subnet.private_backend.*.id)
  tags = {
    Name                  = "${local.name}-private-frontend"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_network_acl_rule" "private_frontend_egress_100" {
  network_acl_id          = aws_network_acl.private_frontend.id
  rule_number             = 100
  egress                  = true
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private_frontend_ingress_100" {
  network_acl_id          = aws_network_acl.private_frontend.id
  rule_number             = 100
  egress                  = false
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = local.vpc_cidr_block
}

# Public
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = cidrsubnet("${var.parameters.subnet_prefix}.${var.parameters.public_ops_3octet}.0/21", 3, count.index)
  count                   = local.az_count
  availability_zone       = element(data.aws_availability_zone.az.*.name, count.index)
  map_public_ip_on_launch = "true"
  depends_on              = [aws_route_table.public]
  tags = {
    Name                  = "${local.name}-public-ops-${element(data.aws_availability_zone.az.*.name_suffix, count.index)}"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table" "public" {
  vpc_id                  = aws_vpc.default.id
  tags = {
    Name                  = "${local.name}-public"
    Environment           = var.common.environment
    Orchestrator          = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_route_table_association" "public" {
  count                   = local.az_count
  depends_on              = [aws_subnet.public]
  subnet_id               = element(aws_subnet.public.*.id, count.index)
  route_table_id          = aws_route_table.public.id
}
resource "aws_route" "public" {
  route_table_id          = aws_route_table.public.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.default.id
}
# Public ACL
resource "aws_network_acl" "public" {
  vpc_id                  = aws_vpc.default.id
  subnet_ids              = concat(aws_subnet.public.*.id)
  tags = {
    Name                  = "${local.name}-public"
    Environment           = var.common.environment
    Deploy_Method         = "terraform"
    Module                = "network"
    Owner                 = var.common.owner
    Project               = var.common.project
    Workspace             = terraform.workspace
  }
}
resource "aws_network_acl_rule" "public_egress_100" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 100
  egress                  = true
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "public_ingress_100" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 100
  egress                  = false
  protocol                = "all"
  rule_action             = "allow"
  cidr_block              = local.vpc_cidr_block
}
resource "aws_network_acl_rule" "public_ingress_110" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 110
  egress                  = false
  protocol                = "tcp"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 22
}
resource "aws_network_acl_rule" "public_ingress_120" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 120
  egress                  = false
  protocol                = "tcp"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 80
}
resource "aws_network_acl_rule" "public_ingress_130" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 130
  egress                  = false
  protocol                = "tcp"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 443
}
resource "aws_network_acl_rule" "public_ingress_200" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 200
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 1443
}
resource "aws_network_acl_rule" "public_ingress_210" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 210
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 1521
}
resource "aws_network_acl_rule" "public_ingress_220" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 220
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 3306
}
resource "aws_network_acl_rule" "public_ingress_230" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 230
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 2049
}
resource "aws_network_acl_rule" "public_ingress_240" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 240
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 3389
}
resource "aws_network_acl_rule" "public_ingress_250" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 250
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 5432
}
resource "aws_network_acl_rule" "public_ingress_260" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 260
  egress                  = false
  protocol                = "tcp"
  rule_action             = "deny"
  cidr_block              = "0.0.0.0/0"
  to_port                 = 8080
}
resource "aws_network_acl_rule" "public_ingress_400" {
  network_acl_id          = aws_network_acl.public.id
  rule_number             = 400
  egress                  = false
  protocol                = "tcp"
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
  from_port               = 1024
  to_port                 = 65535
}
