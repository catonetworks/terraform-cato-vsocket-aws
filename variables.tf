## Cato provider variables
variable "baseurl" {
  description = "Cato API base URL"
  type        = string
  default     = "https://api.catonetworks.com/api/v1/graphql2"
}

variable "token" {
  description = "Cato API token"
  type        = string
  default     = "xxxxxxxx"
}

variable "account_id" {
  description = "Cato account ID"
  type        = number
  default     = "12345"
}

## vSocket Module Varibables
variable "site_description" {
  type        = string
  description = "Site description"
}

variable "site_name" {
  type        = string
  description = "Your Cato Site Deployment Name Here"
  default     = "AWS vSocket site"
}

variable "native_network_range" {
  type        = string
  description = <<EOT
  	Choose the unique network range your vpc is configured with for your socket that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  default     = "10.0.0.0/16"
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
  default = "CLOUD_DC"
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
    city         = "New York"
    country_code = "US"
    state_code   = "US-NY" ## Optinal, for coutries with states only
    timezone     = "America/New_York"
  }
}

## Virtual Socket Variables
variable "vpc_id" {
  description = ""
  type        = string
  default     = "vpc-12345"
}

variable "connection_type" {
  description = "Model of Cato vsocket"
  type        = string
  default     = "SOCKET_AWS1500"
}

variable "ebs_disk_size" {
  description = "Size of disk"
  type        = number
  default     = 32
}

variable "ebs_disk_type" {
  description = "Size of disk"
  type        = string
  default     = "gp2"
}

variable "instance_type" {
  description = "The instance type of the vSocket"
  type        = string
  default     = "c5.xlarge"
  validation {
    condition     = contains(["d2.xlarge", "c3.xlarge", "t3.large", "t3.xlarge", "c4.xlarge", "c5.xlarge", "c5d.xlarge", "c5n.xlarge"], var.instance_type)
    error_message = "The instance_type variable must be one of 'd2.xlarge','c3.xlarge','t3.large','t3.xlarge','c4.xlarge','c5.xlarge','c5d.xlarge','c5n.xlarge'."
  }
}

variable "key_pair" {
  description = "Name of an existing Key Pair for AWS encryption"
  type        = string
  default     = "your-key-pair-name-here"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "mgmt_eni_id" {
  description = "Managent Elastic Network Interface ID, network interface connected public to a subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345"  
  type        = string
  default     = "eni-abcde12345abcde-mgmt"
}

variable "wan_eni_id" {
  description = "WAN Elastic Network Interface ID, network interface connected to a public subnet with routable access to the internet to access the internet and the Cato SASE cloud platform. Example: eni-abcde12345abcde12345"  
  type        = string
  default     = "eni-abcde12345abcde-wan"
}

variable "lan_eni_id" {
  description = "LAN Elastic Network Interface ID, network interface connected to a private subnet for local VPC resources to connect to for access to internet and WAN access through the Cato socket. Example: eni-abcde12345abcde12345"  
  type        = string
  default     = "eni-abcde12345abcde-lan"
}

variable "lan_local_ip" {
  description = "Choose an IP Address within the LAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface used as the default route for private resources to gain access to WAN and internet. The accepted input format is X.X.X.X"
  type        = string
  default     = "10.0.3.5"
}
