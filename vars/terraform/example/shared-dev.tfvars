network = {
  dhcp_domain_name              = "example.com"
  vpc_cidr_block_suffix         = "0.0/16"
  subnet_prefix                 = "10.0"
  include_s3_vpce               = "true"
  private_frontend_3octet       = "20"
  private_backend_3octet        = "30"
  public_3octet                 = "10"
}
