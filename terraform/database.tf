resource "scaleway_rdb_instance" "main" {
  name               = "seemyping-${var.env}"
  node_type          = "DB-DEV-S"
  engine             = "PostgreSQL-16"
  is_ha_cluster      = false
  disable_backup     = true
  user_name          = "dbmanager"
  password           = random_password.dbmanager.result
  encryption_at_rest = true
  private_network {
    pn_id       = scaleway_vpc_private_network.pn_seemyping.id
    enable_ipam = true
  }
}

resource "random_password" "dbmanager" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "scaleway_rdb_database" "main" {
  instance_id = scaleway_rdb_instance.main.id
  name        = var.db_name
}

resource "scaleway_rdb_acl" "main" {
  instance_id = scaleway_rdb_instance.main.id
  acl_rules {
    ip          = scaleway_vpc_private_network.pn_seemyping.ipv4_subnet[0].subnet
    description = "Private network access"
  }
}

resource "random_password" "db_password" {
  length      = 20
  special     = true
  upper       = true
  lower       = true
  numeric     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  # Exclude characters that might cause issues in some contexts
  override_special = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

resource "scaleway_rdb_user" "blogdb" {
  instance_id = scaleway_rdb_instance.main.id
  name        = var.db_user
  password    = random_password.db_password.result
  is_admin    = false
}

resource "scaleway_rdb_privilege" "main" {
  instance_id   = scaleway_rdb_instance.main.id
  user_name     = scaleway_rdb_user.blogdb.name
  database_name = scaleway_rdb_database.main.name
  permission    = "readwrite"
}