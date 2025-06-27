data "cato_accountSnapshotSite" "aws-site" {
  id = cato_socket_site.aws-site.id
}

## Lookup data from region and VPC
data "aws_ami" "vSocket" {
  most_recent = true
  name_regex  = "VSOCKET_AWS"
  owners      = ["aws-marketplace"]
}

data "aws_availability_zones" "available" {
  state = "available"
}
