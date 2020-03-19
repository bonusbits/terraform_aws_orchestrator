data "terraform_remote_state" "network" {
  backend               = "s3"
  config = {
    bucket              = var.common.tfstate_bucket_name
    region              = var.common.tfstate_bucket_region
    key                 = "${var.common.tfstate_bucket_key_prefix}/${terraform.workspace}/network.tfstate"
  }
}

module "s3_bucket_tfstate" {
  source                = "../../modules/s3_bucket"
  common                = var.common
  parameters            = var.bastion
  aws_access_key_id     = data.terraform_remote_state.network.outputs.iam_access_keys.documents.id
  aws_secret_access_key = data.terraform_remote_state.network.outputs.iam_access_keys.documents.secret
  dns_zone_id           = data.terraform_remote_state.network.outputs.dns_zones.schoolcurrent.id
  subnet_ids            = data.terraform_remote_state.network.outputs.subnet_ids.public_ops
  vpc_id                = data.terraform_remote_state.network.outputs.vpc.id
}
