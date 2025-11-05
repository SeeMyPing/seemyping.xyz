terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.61.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://s3.fr-par.scw.cloud"
    }
    skip_requesting_account_id  = true
    bucket                      = "seemyping-tfstates"
    key                         = "infra-state/blog.tfstate"
    region                      = "fr-par"
    skip_credentials_validation = true
    skip_region_validation      = true
    use_path_style              = true
  }
  required_version = ">= 1.13.4"
}

provider "scaleway" {
  alias = "init"
}

data "scaleway_account_project" "seemyping-xyz" {
  provider = scaleway.init
  name     = "seemyping-xyz"
}

provider "scaleway" {
  project_id = data.scaleway_account_project.seemyping-xyz.id
}