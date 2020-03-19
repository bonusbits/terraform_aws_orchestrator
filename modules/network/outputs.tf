# Availability Zones Used
output availability_zones {
  value = data.aws_availability_zone.az
  // object
}
output availability_zones_count {
  value = local.az_count
  // object
}
output "aws_region" {
  value       = local.aws_region
  // object
}
output "aws_region_shortname" {
  value       = local.aws_region_shortname
  // object
}

# VPC
output "vpc" {
  value                 = aws_vpc.default
  // object
}
output "vpce_s3" {
  value                 = aws_vpc_endpoint.s3
  // object
}

# Subnets
output subnets {
  value       = {
    public              = tolist(aws_subnet.public.*),
    private_backend     = tolist(aws_subnet.private_backend.*),
    private_frontend    = tolist(aws_subnet.private_frontend.*)
  }
  // map(list(object))
}
output subnet_ids {
  value       = {
    private_backend     = tolist(aws_subnet.private_backend.*.id),
    private_frontend    = tolist(aws_subnet.private_frontend.*.id),
    public              = tolist(aws_subnet.public.*.id)
  }
  // map(list(string))
}

output "subnet_prefix" {
  value                 = var.parameters.subnet_prefix
  // object
}

# Route Tables
output route_tables {
  value       = {
    private_backend     = aws_route_table.private_backend,
    private_frontend    = aws_route_table.private_frontend
    public              = aws_route_table.public
  }
  // map(object)
}

# Key Pairs
output key_pairs {
  value       = {
    public_instances            = aws_key_pair.public_instances.key_name,
    private_backend_instances   = aws_key_pair.private_backend_instances.key_name
    private_frontend_instances  = aws_key_pair.private_frontend_instances.key_name
  }
  // map(object)
}

# NAT
output "nat" {
  value = aws_eip.nat
  // object
}
