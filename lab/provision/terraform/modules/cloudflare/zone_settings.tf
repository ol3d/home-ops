resource "cloudflare_zone_settings_override" "zone_settings" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  settings {
    # /ssl-tls
    ssl = "strict"
    # /ssl-tls/edge-certificates
    always_use_https = "on"
    min_tls_version = "1.2"
    opportunistic_encryption = "on"
    tls_1_3 = "zrt"
    automatic_https_rewrites = "on"
    universal_ssl = "on"
    # /firewall/settings
    browser_check = "on"
    challenge_ttl = 1800
    privacy_pass = "on"
    security_level = "medium"
    # /speed/optimization
    brotli = "on"
    // Deprecated
    # minify {
    #     css = "on"
    #     js = "on"
    #     html = "on"
    # }
    early_hints = "off"
    rocket_loader = "on"
    # /caching/configuration
    always_online = "off"
    development_mode = "off"
    cache_level = "aggressive"
    browser_cache_ttl = 14400
    # /network
    http3 = "on"
    zero_rtt = "on"
    ipv6 = "on"
    websockets = "on"
    opportunistic_onion = "on"
    pseudo_ipv4 = "off"
    ip_geolocation = "on"
    max_upload = 100
    # /content-protection
    email_obfuscation = "on"
    server_side_exclude = "on"
    hotlink_protection = "off"
    # /workers
    security_header {
      enabled = false
    }
  }
}
