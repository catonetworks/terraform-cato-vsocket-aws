# CATO VSOCKET AWS Terraform module

Terraform module which creates an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.

## NOTE
- Site Location for Cato Socket is automatically inferred based on the region being deployed, however this can be overridden if necessary. 
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
// Initialize Providers
provider "aws" {
  region = "us-east-1"
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.account_id
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "baseurl" {}
variable "token" {}
variable "account_id" {}


// Virtual Socket Resource
module "vsocket-aws" {
  source = "catonetworks/vsocket-aws/cato"
  region               = var.region
  vpc_id               = "vpc-abcde12345abcde"
  key_pair             = "your-keypair-name-here"
  subnet_range_lan     = "10.0.3.0/24"
  mgmt_eni_id          = "eni-abcde12345abcde12mgmt"
  wan_eni_id           = "eni-abcde12345abcde123wan"
  lan_eni_id           = "eni-abcde12345abcde123lan"
  lan_local_ip         = "10.0.3.5"
  site_name            = "AWS Site us-east-2"
  site_description     = "AWS Site us-east-2"
  # site location is inferred from aws region 
  
  # Example Networks to be routed through to AWS
  routed_networks = {
    "Peered-VPC-1" = "10.100.1.0/24"
    "App-VPC" = "10.100.3.0/24"
    "DatabaseVPC" = "10.100.2.0/24"
    }
  
  # Example Tags
  tags = {
    Environment = "Production"
    Owner = "Operations Team"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-aws/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-aws/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.98.00 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | >= 0.0.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.98.00 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | >= 0.0.30 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.vSocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [cato_license.license](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/license) | resource |
| [cato_network_range.routedNetworks](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/network_range) | resource |
| [cato_socket_site.aws-site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/socket_site) | resource |
| [aws_ami.vSocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [cato_accountSnapshotSite.aws-site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/accountSnapshotSite) | data source |
| [cato_siteLocation.site_location](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | Model of Cato vsocket | `string` | `"SOCKET_AWS1500"` | no |
| <a name="input_ebs_disk_size"></a> [ebs\_disk\_size](#input\_ebs\_disk\_size) | Size of disk | `number` | `32` | no |
| <a name="input_ebs_disk_type"></a> [ebs\_disk\_type](#input\_ebs\_disk\_type) | Size of disk | `string` | `"gp3"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the vSocket | `string` | `"c5.xlarge"` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Name of an existing Key Pair for AWS encryption | `string` | `"your-key-pair-name-here"` | no |
| <a name="input_lan_eni_id"></a> [lan\_eni\_id](#input\_lan\_eni\_id) | LAN Elastic Network Interface ID, network interface connected to a private subnet for local VPC resources to connect to for access to internet and WAN access through the Cato socket. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |
| <a name="input_lan_local_ip"></a> [lan\_local\_ip](#input\_lan\_local\_ip) | Choose an IP Address within the LAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface used as the default route for private resources to gain access to WAN and internet. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are not supported for trial accounts. | `string` | `null` | no |
| <a name="input_mgmt_eni_id"></a> [mgmt\_eni\_id](#input\_mgmt\_eni\_id) | Managent Elastic Network Interface ID, network interface connected public to a subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_routed_networks"></a> [routed\_networks](#input\_routed\_networks) | A map of routed networks to be accessed behind the vSocket site. The key is the network name and the value is the CIDR range.<br/>  Example: <br/>  routed\_networks = {<br/>  "Peered-VNET-1" = "10.100.1.0/24"<br/>  "On-Prem-Network" = "192.168.50.0/24"<br/>  "Management-Subnet" = "10.100.2.0/25"<br/>  } | `map(string)` | `{}` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Site description | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly. | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": null,<br/>  "country_code": null,<br/>  "state_code": null,<br/>  "timezone": null<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Your Cato Site Name Here | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_subnet_range_lan"></a> [subnet\_range\_lan](#input\_subnet\_range\_lan) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to AWS resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_wan_eni_id"></a> [wan\_eni\_id](#input\_wan\_eni\_id) | WAN Elastic Network Interface ID, network interface connected to a public subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license"></a> [cato\_license](#output\_cato\_license) | Cato site license info |
| <a name="output_cato_site_name"></a> [cato\_site\_name](#output\_cato\_site\_name) | The Site Name of the Cato Networks Site (CMA) |
| <a name="output_local_ip"></a> [local\_ip](#output\_local\_ip) | The local IP of the Cato vSocket |
| <a name="output_native_network_range"></a> [native\_network\_range](#output\_native\_network\_range) | The Native Network Range of the Cato Networks Site (CMA) |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | n/a |
| <a name="output_socket_site_id"></a> [socket\_site\_id](#output\_socket\_site\_id) | The Site ID of the Cato Networks Site (CMA) |
| <a name="output_socket_site_serial"></a> [socket\_site\_serial](#output\_socket\_site\_serial) | The Serial of the Cato Networks Socket |
| <a name="output_vsocket_instance_ami"></a> [vsocket\_instance\_ami](#output\_vsocket\_instance\_ami) | The AMI used to build the vSocket |
| <a name="output_vsocket_instance_id"></a> [vsocket\_instance\_id](#output\_vsocket\_instance\_id) | The AWS Instance ID of the vSocket |
| <a name="output_vsocket_instance_public_ip"></a> [vsocket\_instance\_public\_ip](#output\_vsocket\_instance\_public\_ip) | The Public IP of the vSocket |
<!-- END_TF_DOCS -->