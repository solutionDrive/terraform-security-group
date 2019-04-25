provider "aws" {
  alias = "module"
  region = "${var.provider_region}"
  profile = "${var.profile}"
  assume_role {
    role_arn = "${var.assume_role_arn}"
  }
}

resource "aws_security_group" "security_group" {
  provider = "aws.module"
  name = "${var.name}"
  description = "${var.description}"
  vpc_id = "${var.vpc_id}"
  tags = "${merge(var.custom_tags, map("Name", var.name))}"
}

##### IPv4 #####
#
# Iterates over all given ingress rules and uses some build-in terraform functionality to create all
# Ingress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#

resource "aws_security_group_rule" "cidr_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  count = "${var.cidr_ipv4_ingress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.cidr_ipv4_ingress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.cidr_ipv4_ingress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.cidr_ipv4_ingress_rules["protocols"]), count.index)}"

  cidr_blocks = "${split(",", element(split("~~~", var.cidr_ipv4_ingress_rules["cidr_blocks"]), count.index))}"

  description = "${element(split(",", element(split("~~~", var.cidr_ipv4_ingress_rules["descriptions"]), count.index)), count.index)}"
}

#
# Iterates over all given egress rules and uses some build-in terraform functionality to create all
# Egress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#
resource "aws_security_group_rule" "cidr_egress_rule" {
  provider = "aws.module"
  type = "egress"

  count = "${var.cidr_ipv4_egress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.cidr_ipv4_egress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.cidr_ipv4_egress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.cidr_ipv4_egress_rules["protocols"]), count.index)}"

  cidr_blocks = "${split(",", element(split("~~~", var.cidr_ipv4_egress_rules["cidr_blocks"]), count.index))}"

  description = "${element(split(",", element(split("~~~", var.cidr_ipv4_egress_rules["descriptions"]), count.index)), count.index)}"
}

##### IPv6 #####
#
# Iterates over all given ipv6 ingress rules and uses some build-in terraform functionality to create all
# Ingress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#

resource "aws_security_group_rule" "cidr_ipv6_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  count = "${var.cidr_ipv6_ingress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.cidr_ipv6_ingress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.cidr_ipv6_ingress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.cidr_ipv6_ingress_rules["protocols"]), count.index)}"

  ipv6_cidr_blocks = "${split(",", element(split("~~~", var.cidr_ipv6_ingress_rules["ipv6_cidr_blocks"]), count.index))}"

  description = "${element(split(",", element(split("~~~", var.cidr_ipv6_ingress_rules["descriptions"]), count.index)), count.index)}"
}

#
# Iterates over all given ipv6 egress rules and uses some build-in terraform functionality to create all
# Egress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#
resource "aws_security_group_rule" "cidr_ipv6_egress_rule" {
  provider = "aws.module"
  type = "egress"

  count = "${var.cidr_ipv6_egress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.cidr_ipv6_egress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.cidr_ipv6_egress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.cidr_ipv6_egress_rules["protocols"]), count.index)}"

  ipv6_cidr_blocks = "${split(",", element(split("~~~", var.cidr_ipv6_egress_rules["ipv6_cidr_blocks"]), count.index))}"

  description = "${element(split(",", element(split("~~~", var.cidr_ipv6_egress_rules["descriptions"]), count.index)), count.index)}"
}

##### SecurityGroups #####
#
# Iterates over all given ingress rules and uses some build-in terraform functionality to create all
# Ingress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#
resource "aws_security_group_rule" "sg_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  count = "${var.security_group_ingress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.security_group_ingress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.security_group_ingress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.security_group_ingress_rules["protocols"]), count.index)}"

  source_security_group_id = "${element(split("~~~", var.security_group_ingress_rules["source_security_groups"]), count.index) == "self" ? aws_security_group.security_group.id : element(split("~~~", var.security_group_ingress_rules["source_security_groups"]), count.index)}"

  description = "${element(split(",", element(split("~~~", var.security_group_ingress_rules["descriptions"]), count.index)), count.index)}"
}

#
# Iterates over all given egress rules and uses some build-in terraform functionality to create all
# Egress-Rules.
# see (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
#
resource "aws_security_group_rule" "sg_egress_rule" {
  provider = "aws.module"
  type = "egress"

  count = "${var.security_group_egress_rules_count}"
  security_group_id = "${aws_security_group.security_group.id}"

  from_port = "${element(split("~~~", var.security_group_egress_rules["ports"]), count.index)}"
  to_port = "${element(split("~~~", var.security_group_egress_rules["ports"]), count.index)}"
  protocol = "${element(split("~~~", var.security_group_egress_rules["protocols"]), count.index)}"

  source_security_group_id = "${element(split("~~~", var.security_group_egress_rules["source_security_groups"]), count.index) == "self" ? aws_security_group.security_group.id : element(split("~~~", var.security_group_egress_rules["source_security_groups"]), count.index)}"

  description = "${element(split(",", element(split("~~~", var.security_group_egress_rules["descriptions"]), count.index)), count.index)}"
}
