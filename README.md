# CATO VSOCKET AWS Terraform module

Terraform module which creates an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.

## Usage

```hcl
module "vsocket-aws" {
  source = "catonetworks/vsocket-aws/cato"
  token = "xxxxxxx"
  account_id = "xxxxxxx"
  vpc_id               = "vpc-abcde12345abcde"
  instance_type        = "c5.xlarge"
  key_pair             = "your-keypair-name-here"
  lan_eni_id           = "eni-abcde12345abcde123lan"
  lan_local_ip         = "10.0.3.5"
  mgmt_eni_id          = "eni-abcde12345abcde12mgmt"
  native_network_range = "10.0.0.0/16"
  region               = "us-east-2"
  site_name            = "AWS Site us-east-2"
  wan_eni_id           = "eni-abcde12345abcde123wan"
  site_description     = "AWS Site us-east-2"
  site_type            = "CLOUD_DC"
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
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

