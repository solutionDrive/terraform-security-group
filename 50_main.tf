##### Main Security Group #####
resource "aws_security_group" "security_group" {
  provider = "aws.module"
  name = var.name
  description = var.description
  vpc_id = var.vpc_id
  tags = merge(var.custom_tags, map("Name", var.name))
}

##### IPv4 #####
resource "aws_security_group_rule" "cidr_ipv4_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  for_each = split("~~~", var.cidr_ipv4_ingress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.cidr_ipv4_ingress_rules["ports"][each.key]
  protocol = var.cidr_ipv4_ingress_rules["protocols"][each.key]

  cidr_blocks = element(split(",", var.cidr_ipv4_ingress_rules["cidr_blocks"][each.key]))

  description = element(split(",", var.cidr_ipv4_ingress_rules["descriptions"][each.key]))
}

resource "aws_security_group_rule" "cidr_ipv4_egress_rule" {
  provider = "aws.module"
  type = "egress"

  for_each = split("~~~", var.cidr_ipv4_egress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.cidr_ipv4_egress_rules["ports"][each.key]
  protocol = var.cidr_ipv4_egress_rules["protocols"][each.key]

  cidr_blocks = element(split(",", var.cidr_ipv4_egress_rules["cidr_blocks"][each.key]))

  description = element(split(",", var.cidr_ipv4_egress_rules["descriptions"][each.key]))
}

##### IPv6 #####
resource "aws_security_group_rule" "cidr_ipv6_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  for_each = split("~~~", var.cidr_ipv6_ingress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.cidr_ipv6_ingress_rules["ports"][each.key]
  protocol = var.cidr_ipv6_ingress_rules["protocols"][each.key]

  ipv6_cidr_blocks = element(split(",", var.cidr_ipv6_ingress_rules["ipv6_cidr_blocks"][each.key]))

  description = element(split(",", var.cidr_ipv6_ingress_rules["descriptions"][each.key]))
}

resource "aws_security_group_rule" "cidr_ipv6_egress_rule" {
  provider = "aws.module"
  type = "egress"

  for_each = split("~~~", var.cidr_ipv6_egress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.cidr_ipv6_egress_rules["ports"][each.key]
  protocol = var.cidr_ipv6_egress_rules["protocols"][each.key]

  ipv6_cidr_blocks = element(split(",", var.cidr_ipv6_egress_rules["ipv6_cidr_blocks"][each.key]))

  description = element(split(",", var.cidr_ipv6_egress_rules["descriptions"][each.key]))
}

##### SecurityGroups #####
resource "aws_security_group_rule" "sg_ingress_rule" {
  provider = "aws.module"
  type = "ingress"

  for_each = split("~~~", var.security_group_ingress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.security_group_ingress_rules["ports"][each.key]
  protocol = var.security_group_ingress_rules["protocols"][each.key]

  source_security_group_id = var.security_group_ingress_rules["source_security_groups"][each.key] == "self" ? aws_security_group.security_group.id : var.security_group_ingress_rules["source_security_groups"][each.key]

  description = element(split(",", var.security_group_ingress_rules["descriptions"][each.key]))
}

resource "aws_security_group_rule" "sg_egress_rule" {
  provider = "aws.module"
  type = "egress"

  for_each = split("~~~", var.security_group_egress_rules["ports"])

  security_group_id = aws_security_group.security_group.id

  from_port = each.value
  to_port = var.security_group_egress_rules["ports"][each.key]
  protocol = var.security_group_egress_rules["protocols"][each.key]

  source_security_group_id = var.security_group_egress_rules["source_security_groups"][each.key] == "self" ? aws_security_group.security_group.id : var.security_group_egress_rules["source_security_groups"][each.key]

  description = element(split(",", var.security_group_egress_rules["descriptions"][each.key]))
}
