locals {
  # Check if user provided site_location (any field is non-null)
  use_user_location = (
    var.site_location.city != null ||
    var.site_location.country_code != null ||
    var.site_location.state_code != null ||
    var.site_location.timezone != null
  )

  region_key = lower(replace(var.region, " ", ""))

  # Hardcoded mapping from AWS region to Cato site location values
  # Values retrieved from Cato siteLocation API
  region_to_site_location = {
    # North America - United States
    "us-east-1"     = { city = "Ashburn", country_code = "US", state_code = "US-VA", timezone = "America/New_York" }
    "us-east-2"     = { city = "Columbus", country_code = "US", state_code = "US-OH", timezone = "America/New_York" }
    "us-west-1"     = { city = "San Francisco", country_code = "US", state_code = "US-CA", timezone = "America/Los_Angeles" }
    "us-west-2"     = { city = "Boardman", country_code = "US", state_code = "US-OR", timezone = "America/Los_Angeles" }
    "us-gov-east-1" = { city = "Fairfax", country_code = "US", state_code = "US-VA", timezone = "America/New_York" }
    "us-gov-west-1" = { city = "Boardman", country_code = "US", state_code = "US-OR", timezone = "America/Los_Angeles" }

    # North America - Canada
    "ca-central-1" = { city = "Montréal", country_code = "CA", state_code = null, timezone = "America/Toronto" }
    "ca-west-1"    = { city = "Calgary", country_code = "CA", state_code = null, timezone = "America/Edmonton" }

    # North America - Mexico (uses Austin, TX as nearest)
    "mx-central-1" = { city = "Austin", country_code = "US", state_code = "US-TX", timezone = "America/Chicago" }

    # Europe
    "eu-central-1" = { city = "Frankfurt am Main", country_code = "DE", state_code = null, timezone = "Europe/Berlin" }
    "eu-central-2" = { city = "Zürich", country_code = "CH", state_code = null, timezone = "Europe/Zurich" }
    "eu-west-1"    = { city = "Dublin", country_code = "IE", state_code = null, timezone = "Europe/Dublin" }
    "eu-west-2"    = { city = "London", country_code = "GB", state_code = null, timezone = "Europe/London" }
    "eu-west-3"    = { city = "Paris", country_code = "FR", state_code = null, timezone = "Europe/Paris" }
    "eu-north-1"   = { city = "Stockholm", country_code = "SE", state_code = null, timezone = "Europe/Stockholm" }
    "eu-south-1"   = { city = "Milan", country_code = "IT", state_code = null, timezone = "Europe/Rome" }
    "eu-south-2"   = { city = "Madrid", country_code = "ES", state_code = null, timezone = "Europe/Madrid" }

    # Asia Pacific
    "ap-east-1"      = { city = "Hong Kong", country_code = "HK", state_code = null, timezone = "Asia/Hong_Kong" }
    "ap-east-2"      = { city = "Taipei", country_code = "TW", state_code = null, timezone = "Asia/Taipei" }
    "ap-south-1"     = { city = "Mumbai", country_code = "IN", state_code = "IN-MH", timezone = "Asia/Kolkata" }
    "ap-south-2"     = { city = "Chennai", country_code = "IN", state_code = "IN-TN", timezone = "Asia/Kolkata" }
    "ap-northeast-1" = { city = "Tokyo", country_code = "JP", state_code = null, timezone = "Asia/Tokyo" }
    "ap-northeast-2" = { city = "Seoul", country_code = "KR", state_code = null, timezone = "Asia/Seoul" }
    "ap-northeast-3" = { city = "Osaka", country_code = "JP", state_code = null, timezone = "Asia/Tokyo" }
    "ap-southeast-1" = { city = "Singapore", country_code = "SG", state_code = null, timezone = "Asia/Singapore" }
    "ap-southeast-2" = { city = "Sydney", country_code = "AU", state_code = "AU-NSW", timezone = "Australia/Sydney" }
    "ap-southeast-3" = { city = "Jakarta", country_code = "ID", state_code = null, timezone = "Asia/Jakarta" }
    "ap-southeast-4" = { city = "Melbourne", country_code = "AU", state_code = "AU-VIC", timezone = "Australia/Melbourne" }
    "ap-southeast-5" = { city = "Kuala Lumpur", country_code = "MY", state_code = null, timezone = "Asia/Kuala_Lumpur" }
    "ap-southeast-7" = { city = "Bangkok", country_code = "TH", state_code = null, timezone = "Asia/Bangkok" }

    # Middle East
    "me-south-1"   = { city = "Manama", country_code = "BH", state_code = null, timezone = "Asia/Bahrain" }
    "me-central-1" = { city = "Dubai", country_code = "AE", state_code = null, timezone = "Asia/Dubai" }
    "il-central-1" = { city = "Tel Aviv", country_code = "IL", state_code = null, timezone = "Asia/Jerusalem" }

    # Africa
    "af-south-1" = { city = "Cape Town", country_code = "ZA", state_code = null, timezone = "Africa/Johannesburg" }

    # South America
    "sa-east-1" = { city = "São Paulo", country_code = "BR", state_code = "BR-SP", timezone = "UTC-3" }

    # China (Isolated regions)
    "cn-north-1"     = { city = "Beijing", country_code = "CN", state_code = null, timezone = "Asia/Shanghai" }
    "cn-northwest-1" = { city = "Beijing", country_code = "CN", state_code = null, timezone = "Asia/Shanghai" }
  }

  # Use user-provided location if any field is set, otherwise use hardcoded mapping
  cur_site_location = local.use_user_location ? var.site_location : local.region_to_site_location[local.region_key]
}
