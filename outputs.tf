##The following attributes are exported:
output "serial" { 
    value = data.cato_accountSnapshotSite.aws-site.info.sockets[0].serial 
    description = "Unique serial number used to register the vsocket ec2 instance to the socket site in the Cato Cloud."
}
