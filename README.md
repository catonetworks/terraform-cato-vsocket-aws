# CATO VSOCKET AWS Terraform module

Terraform module which creates an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.

## Usage

```hcl
// Data Source for siteLocation
data "cato_siteLocation" "ny" {
  filters = [{
    field = "city"
    search = "New York"
    operation = "startsWith"
  },
  {
    field = "state_name"
    search = "New York"
    operation = "exact"
  },
 {
    field = "country_name"
    search = "United"
    operation = "contains"
  }]
}

// Virtual Socket Resource
module "vsocket-aws" {
  source = "catonetworks/vsocket-aws/cato"
  token = "xxxxxxx"
  account_id = "xxxxxxx"
  vpc_id               = "vpc-abcde12345abcde"
  key_pair             = "your-keypair-name-here"
  native_network_range = "10.0.0.0/16"
  region               = "us-east-2"
  mgmt_eni_id          = "eni-abcde12345abcde12mgmt"
  wan_eni_id           = "eni-abcde12345abcde123wan"
  lan_eni_id           = "eni-abcde12345abcde123lan"
  lan_local_ip         = "10.0.3.5"
  site_name            = "AWS Site us-east-2"
  site_description     = "AWS Site us-east-2"
  site_location = {
    country_code = data.cato_siteLocation.ny.locations[1].country_code
    state_code = data.cato_siteLocation.ny.locations[1].state_code
    timezone = data.cato_siteLocation.ny.locations[1].timezone[0]
  }
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.72.1 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | 0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.vSocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| cato_socket_site.aws-site | resource |
| [aws_ami.vSocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| cato_accountSnapshotSite.aws-site | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cato account ID | `number` | n/a | yes |
| <a name="input_baseurl"></a> [baseurl](#input\_baseurl) | Cato API base URL | `string` | `"https://api.catonetworks.com/api/v1/graphql2"` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | Model of Cato vsocket | `string` | `"SOCKET_AWS1500"` | no |
| <a name="input_ebs_disk_size"></a> [ebs\_disk\_size](#input\_ebs\_disk\_size) | Size of disk | `number` | `32` | no |
| <a name="input_ebs_disk_type"></a> [ebs\_disk\_type](#input\_ebs\_disk\_type) | Size of disk | `string` | `"gp2"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the vSocket | `string` | `"c5.xlarge"` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Name of an existing Key Pair for AWS encryption | `string` | `"your-key-pair-name-here"` | no |
| <a name="input_lan_eni_id"></a> [lan\_eni\_id](#input\_lan\_eni\_id) | LAN Elastic Network Interface ID, network interface connected to a private subnet for local VPC resources to connect to for access to internet and WAN access through the Cato socket. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |
| <a name="input_lan_local_ip"></a> [lan\_local\_ip](#input\_lan\_local\_ip) | Choose an IP Address within the LAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface used as the default route for private resources to gain access to WAN and internet. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_mgmt_eni_id"></a> [mgmt\_eni\_id](#input\_mgmt\_eni\_id) | Managent Elastic Network Interface ID, network interface connected public to a subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Choose the unique network range your vpc is configured with for your socket that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Site description | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | The location of the site, used for timezone and geolocation.  Use the Cato CLI to get the list of locations. []() | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Your Cato Site Name Here | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to AWS resources | `map(string)` | `{}` | no |
| <a name="input_token"></a> [token](#input\_token) | Cato API token | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_wan_eni_id"></a> [wan\_eni\_id](#input\_wan\_eni\_id) | WAN Elastic Network Interface ID, network interface connected to a public subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_site_name"></a> [cato\_site\_name](#output\_cato\_site\_name) | The Site Name of the Cato Networks Site (CMA) |
| <a name="output_local_ip"></a> [local\_ip](#output\_local\_ip) | The local IP of the Cato vSocket |
| <a name="output_native_network_range"></a> [native\_network\_range](#output\_native\_network\_range) | The Native Network Range of the Cato Networks Site (CMA) |
| <a name="output_socket_site_id"></a> [socket\_site\_id](#output\_socket\_site\_id) | The Site ID of the Cato Networks Site (CMA) |
| <a name="output_socket_site_serial"></a> [socket\_site\_serial](#output\_socket\_site\_serial) | The Serial of the Cato Networks Socket |
| <a name="output_vsocket_instance_ami"></a> [vsocket\_instance\_ami](#output\_vsocket\_instance\_ami) | The AMI used to build the vSocket |
| <a name="output_vsocket_instance_id"></a> [vsocket\_instance\_id](#output\_vsocket\_instance\_id) | The AWS Instance ID of the vSocket |
| <a name="output_vsocket_instance_public_ip"></a> [vsocket\_instance\_public\_ip](#output\_vsocket\_instance\_public\_ip) | The Public IP of the vSocket |
<!-- END_TF_DOCS -->