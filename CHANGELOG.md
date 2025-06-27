# Changelog

## 0.0.4 (2024-10-18)

### Features
- Initial commit with single socket instance with 3 NICs
- Added default vales for required parameters

## 0.0.7 (2024-11-13)

### Features
- updated readme and added outputs for id and serial for site

## 0.0.11 (2025-04-24)

### Features
- updated readme with siteLocation examples and auto-generated parameters
- extracted provider from module to be passed in
- updated addtional outputs

## 0.0.12 (2025-04-24)

### Features
- Purged legacy variables for cato_token and account_id from removing provider from module

## 0.0.14 (2025-04-24)

### Features
- Purged legacy variables for region and baseurl of provider params from module
- Regenerated documentation in readme updating variables 

## 0.0.15 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.0.16 (2025-05-30)

### Features
- Adjusted EBS Disk type from GP2 to GP3

## 0.0.17 (2025-06-27)

### Features
- Added automatic site_location - site_location is inferred based on AWS Region 
- Added Routed_Networks functionality - Routed Networks are created in Cato based on input to the module 
- Cleaned up Variables and moved locals to the locals.tf file 
- Moved data calls to data.tf file
- Updated Readme File 
- Updated Versions to latest cato provider, aws_provider 
- Removed native_network for site configuration, inferred from lan_subnet via a for_each