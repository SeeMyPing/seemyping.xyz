resource "scaleway_domain_record" "www" {
  dns_zone = "seemyping.xyz"
  name     = "www"
  type     = "CNAME"
  data     = "seemyping.xyz."
  ttl      = 3600
}

resource "scaleway_domain_record" "to-container" {
  dns_zone = "seemyping.xyz"
  name     = ""
  type     = "CNAME"
  data     = scaleway_container.seemyping-xyz.domain_name
  ttl      = 3600
}