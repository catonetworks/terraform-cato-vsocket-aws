resource "cato_socket_site" "aws-site" {
  connection_type = var.connection_type
  description     = var.site_description
  name            = var.site_name
  native_range = {
    native_network_range = var.subnet_range_lan
    local_ip             = var.lan_local_ip
  }
  site_location = local.cur_site_location
  site_type     = var.site_type
}

resource "cato_network_range" "routedNetworks" {
  for_each        = var.routed_networks
  site_id         = cato_socket_site.aws-site.id
  name            = each.key # The name is the key from the map item.
  range_type      = "Routed"
  subnet          = each.value.subnet # The subnet is the value from the map item.
  interface_index = each.value.interface_index
  gateway         = local.default_subnet_gateway
  depends_on      = [aws_instance.vSocket]
}


## vSocket Instance
resource "aws_instance" "vSocket" {
  tenancy          = "default"
  ami              = data.aws_ami.vSocket.id
  key_name         = var.key_pair
  instance_type    = var.instance_type
  user_data_base64 = base64encode(data.cato_accountSnapshotSite.aws-site.info.sockets[0].serial)

  # Network Interfaces
  # WANENI
  primary_network_interface {
    network_interface_id = var.wan_eni_id
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.ebs_disk_size
    volume_type = var.ebs_disk_type
    encrypted   = true
  }
  tags = merge(var.tags, {
    Name = "${var.site_name}-vSocket"
  })
}

# MGMTENI
resource "aws_network_interface_attachment" "mgmt-int" {
  instance_id          = aws_instance.vSocket.id
  network_interface_id = var.mgmt_eni_id
  device_index         = 1
}

# LANENI
resource "aws_network_interface_attachment" "lan-int" {
  instance_id          = aws_instance.vSocket.id
  network_interface_id = var.lan_eni_id
  device_index         = 2
}

resource "null_resource" "reboot_once" {
  # Only runs on creation, not subsequent applies
  triggers = {
    instance_id = aws_instance.vSocket.id
  }
  provisioner "local-exec" {
    command = "sleep 15 && aws ec2 reboot-instances --instance-ids ${aws_instance.vSocket.id} --region ${var.region}"
  }
  depends_on = [aws_instance.vSocket]
}

resource "cato_license" "license" {
  depends_on = [aws_instance.vSocket]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_socket_site.aws-site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}
