// https://registry.terraform.io/modules/trussworks/destroy-default-vpc/aws/latest

data "aws_regions" "current" {}

module "destroy_default_vpcs" {
  source = "trussworks/destroy-default-vpc/aws"
  for_each = toset(data.aws_regions.current.names)
  region = each.value
}