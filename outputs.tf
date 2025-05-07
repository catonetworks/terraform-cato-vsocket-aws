# The following attributes are exported:
output "socket_site_id" {
  value       = cato_socket_site.aws-site.id
  description = "The Site ID of the Cato Networks Site (CMA)"
}

output "socket_site_serial" {
  value       = data.cato_accountSnapshotSite.aws-site.info.sockets[0].serial
  description = "The Serial of the Cato Networks Socket"
}

output "vsocket_instance_id" {
  value       = aws_instance.vSocket.id
  description = "The AWS Instance ID of the vSocket"
}

output "vsocket_instance_public_ip" {
  value       = aws_instance.vSocket.public_ip
  description = "The Public IP of the vSocket"
}

output "vsocket_instance_ami" {
  value       = aws_instance.vSocket.ami
  description = "The AMI used to build the vSocket"
}

output "cato_site_name" {
  value       = cato_socket_site.aws-site.name
  description = "The Site Name of the Cato Networks Site (CMA)"
}

output "native_network_range" {
  value       = cato_socket_site.aws-site.native_range.native_network_range
  description = "The Native Network Range of the Cato Networks Site (CMA)"
}

output "local_ip" {
  value       = cato_socket_site.aws-site.native_range.local_ip
  description = "The local IP of the Cato vSocket"
}

output "cato_license" { 
  description = "Cato site license info"
  value = var.license_id==null ? null : cato_license.license 
}