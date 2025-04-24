# The following attributes are exported:
# The following attributes are exported:
output "socket_site_id" {
  value = cato_socket_site.aws-site.id
}

output "socket_site_serial" {
  value = data.cato_accountSnapshotSite.aws-site.info.sockets[0].serial
}

output "vsocket_instance_id" {
  value = aws_instance.vSocket.id
}

output "vsocket_instance_public_ip" {
  value = aws_instance.vSocket.public_ip
}

output "vsocket_instance_ami" {
  value = aws_instance.vSocket.ami
}

output "cato_site_id" {
  value = cato_socket_site.aws-site.id
}

output "cato_site_name" {
  value = cato_socket_site.aws-site.name
}

output "native_network_range" {
  value = cato_socket_site.aws-site.native_range.native_network_range
}

output "translated_subnet" {
  value = cato_socket_site.aws-site.native_range.translated_subnet
}

output "local_ip" {
  value = cato_socket_site.aws-site.native_range.local_ip
}