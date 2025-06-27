locals {
  default_subnet_gateway = cidrhost(var.subnet_range_lan, 1)
}