module "vpc" {
  source = "../modules/vpc"

  env_code                        = var.env_code
  vpc_cidr                        = var.vpc_cidr
  private_cidr                    = var.private_cidr
  public_cidr                     = var.public_cidr
  eip                             = var.eip
  nat_gateway                     = var.nat_gateway
  public_route_table              = var.public_route_table
  private_route_table             = var.private_route_table
  public_route_table_association  = var.public_route_table_association
  private_route_table_association = var.private_route_table_association

}
