# Basic Variables
variable "profile" {
  description = "the AWS profile to use"
}

variable "vpc_id" {
  description = "ID of the VPC the security_group should be connected to"
}

variable "description" {
  description = "The description of the security group"
}

variable "name" {
  description = "The name of the security group"
}

variable "custom_tags" {
  type = map(string)
  default = {}
}

variable "assume_role_arn" {
  description = "ARN of the role to use"
  default = ""
}

variable "provider_region" {}

variable "account_id" {
  description = "Account id (deprecated | please use the 'assume_role_arn' variable)"
  default = ""
}

# Variables for IPv4 cidr_based rules
variable "cidr_ipv4_ingress_rules" {
  description = "Ports to be allowed for ingress connections based on cidr-blocks. The needed values are protocols, cidr_blocks, ports"
  type = map(string)
  default = {
    "protocols" = "tcp",
    "ports" = "",
    "cidr_blocks" = ""
    "descriptions" = ""
  }
}

variable "cidr_ipv4_egress_rules" {
  description = "Ports to be allowed for egress connections based on cidr-blocks. The needed values are protocols, cidr_blocks, ports"
  type = map(string)
  default = {
    "protocols" = "-1",
    "ports" = "0"
    "cidr_blocks" = "0.0.0.0/0"
    "descriptions" = ""
  }
}

# Variables for IPv6 cidr_based rules
variable "cidr_ipv6_ingress_rules" {
  description = "Ports to be allowed for ingress ipv6 connections based on cidr-blocks. The needed values are protocols, ipv6_cidr_blocks, ports"
  type = map(string)
  default = {
    "protocols" = "tcp",
    "ports" = "",
    "ipv6_cidr_blocks" = ""
    "descriptions" = ""
  }
}

variable "cidr_ipv6_egress_rules" {
  description = "Ports to be allowed for egress ipv6 connections based on cidr-blocks. The needed values are protocols, ipv6_cidr_blocks, ports"
  type = map(string)
  default = {
    "protocols" = "-1"
    "ports" = "0"
    "ipv6_cidr_blocks" = "::/0"
    "descriptions" = ""
  }
}

# Variables for security_group based rules
variable "security_group_ingress_rules" {
  description = "Ports to be allowed for ingress connections based on security_groups. The needed values are protocols, source_security_groups, ports"
  type = map(string)
  default = {
    "protocols" = "tcp",
    "ports" = "",
    "source_security_groups" = "id"
    "descriptions" = ""
  }
}

variable "security_group_egress_rules" {
  description = "Ports to be allowed for egress connections based on security_groups. The needed values are protocols, source_security_groups, ports"
  type = map(string)
  default = {
    "protocols" = "tcp",
    "ports" = "",
    "source_security_groups" = "id"
    "descriptions" = ""
  }
}

variable "source_security_group" {
  description = "The security group to/from which the access should be granted"
  default = ""
}
