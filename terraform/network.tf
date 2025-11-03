resource "scaleway_vpc" "vpc" {
  name = "VPC-seemyping-${var.env}"
  tags = ["seemyping", var.env, "terraform"]
}

resource "scaleway_vpc_private_network" "pn_seemyping" {
  name   = "subnet"
  tags   = ["seemyping", "terraform"]
  vpc_id = scaleway_vpc.vpc.id
}