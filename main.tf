resource "cato_socket_site" "aws-site" {
  connection_type = var.connection_type
  description     = var.site_description
  name            = var.site_name
  native_range = {
    native_network_range = var.native_network_range
    local_ip             = var.lan_local_ip
  }
  site_location = var.site_location
  site_type     = var.site_type
}

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

## vSocket Instance
resource "aws_instance" "vSocket" {
  tenancy       = "default"
  ami           = data.aws_ami.vSocket.id
  key_name      = var.key_pair
  instance_type = var.instance_type
  user_data     = base64encode(data.cato_accountSnapshotSite.aws-site.info.sockets[0].serial)
  # Network Interfaces
  # MGMTENI
  network_interface {
    device_index         = 1
    network_interface_id = var.mgmt_eni_id
  }
  # WANENI
  network_interface {
    device_index         = 0
    network_interface_id = var.wan_eni_id
  }
  # LANENI
  network_interface {
    device_index         = 2
    network_interface_id = var.lan_eni_id
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.ebs_disk_size
    volume_type = var.ebs_disk_type
  }
  tags = merge(var.tags, {
    Name = "${var.site_name}-vSocket"
  })
}

resource "cato_license" "license" {
  depends_on = [aws_instance.vSocket]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_socket_site.aws-site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}
