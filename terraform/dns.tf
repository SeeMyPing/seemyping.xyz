data "scaleway_account_project" "default" {
  name = "default"
}


resource "scaleway_domain_record" "www" {
  project_id = data.scaleway_account_project.default.id
  dns_zone   = "seemyping.xyz"
  name       = "www"
  type       = "CNAME"
  data       = "${scaleway_container.seemyping-xyz.domain_name}."
  ttl        = 180
}

resource "scaleway_domain_record" "root" {
  project_id = data.scaleway_account_project.default.id
  dns_zone   = "seemyping.xyz"
  name       = ""
  type       = "ALIAS"
  data       = "${scaleway_container.seemyping-xyz.domain_name}."
  ttl        = 180
}
