resource "scaleway_container_namespace" "seemyping-xyz" {
  name        = "ns-seemyping"
  description = "Container namespace for seemyping"
}

data "scaleway_registry_namespace" "seemyping-xyz" {
  name = "ns-seemyping-xyz"
}

resource "scaleway_container" "seemyping-xyz" {
  name           = "seemyping-xyz"
  description    = "SeeMyPing blog"
  tags           = ["terraform", var.env]
  namespace_id   = scaleway_container_namespace.seemyping-xyz.id
  registry_image = "${data.scaleway_registry_namespace.seemyping-xyz.endpoint}/seemyping-xyz:0.0.3"
  port           = 8000
  cpu_limit      = 500
  memory_limit   = 1024
  min_scale      = 0
  max_scale      = 1
  timeout        = 60
  protocol       = "http1"
  deploy         = true

  command = ["gunicorn", "seemyping.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "1", "--timeout", "60", "--chdir", "/app"]

  environment_variables = {
    "DEBUG"   = "False"
    "DB_NAME" = var.db_name
    "DB_USER" = var.db_user
    "DB_HOST" = scaleway_rdb_instance.main.private_network[0].ip
    "DB_PORT" = scaleway_rdb_instance.main.private_network[0].port

    "S3_ACCESS_KEY" = scaleway_iam_api_key.seemyping.access_key
    "S3_REGION"   = scaleway_object_bucket.seemyping-xyz-staticfiles.region
    "S3_ENDPOINT" = scaleway_object_bucket.seemyping-xyz-staticfiles.endpoint
    "BUCKET_NAME" = var.bucket_name
  }
  secret_environment_variables = {
    "DB_PASSWORD"   = random_password.db_password.result
    "SECRET_KEY"    = random_password.secret_key.result
    "S3_SECRET_KEY" = scaleway_iam_api_key.seemyping.secret_key
  }

  private_network_id = scaleway_vpc_private_network.pn_seemyping.id
}

resource "random_password" "secret_key" {
  length      = 64
  special     = true
  upper       = true
  lower       = true
  numeric     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "scaleway_container_domain" "domain" {
  container_id = scaleway_container.seemyping-xyz.id
  hostname     = "seemyping.xyz"
}

resource "scaleway_container_domain" "domain-www" {
  container_id = scaleway_container.seemyping-xyz.id
  hostname     = "www.seemyping.xyz"
}