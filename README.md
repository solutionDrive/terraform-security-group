# terraform-security-group
Terraform-Module for creating security-groups for terraform v0.11.x.
In future releases of terraform a lot of this hopefully won't be necessary anymore.

Till then, we hope this module can help others out there.
Good Luck!

### Input Parameters

see variables.tf

**__caution!!__**
Due to terraform the following is absolutley important
To be able to generate security_groups with a dynamic amount of ingress/egress rules some tripwires should be known
1. each Port defined in one of the *_rules-variables will lead to a new rule for this port
2. for each Port a protocol has to be defined, even if they are all the same
3. in cidr_based rules, it is possible to define multiple cidr-blocks per rule. In this case the Delimiter for 2 rules is '~~~' 


### Output Parameters
+ security_group_id: The ID of the created security-group

### Example
```hcl-terraform
module "security_group_webserver" {
  source = "git::ssh://git@github.com:solutionDrive/terraform-security-group.git"
    # Basic stuff
    profile = "Name of AWS Profile to use"
    name = "name_of_your_security_group"
    description = "desctiption of your security group"
    vpc_id = "${var.vpc_id}"
  
    # cidr-rules related stuff
    cidr_ingress_rules = {
      "ports"  = "80~~~443~~~22"
      "protocols" = "tcp~~~tcp~~~tcp"
      "cidr_blocks" = "your.ip.address.here/32,your.second.ip.address/32~~~your.ip.address.here/32,your.second.ip.address/32~~~0.0.0.0/0"
      "descriptions" = "your-description-here,somebody-elses-desciption~~~still-your-description-here,still-somebody-elses-desciption~~~the evil rest"
    }
    cidr_ingress_rules_count = 3 # This count has to equal the amount of Ports defined in <cidr_ingress_rules>
    
    # security_group related stuff
    security_group_ingress_rules = {
      "ports" = "6379"
      "protocols" = "tcp"
      "source_security_groups" = "self"
      "descriptions" = "That is me"
    }
    security_group_ingress_rules_count = 1 # This count has to equal the amount of Ports defined in <security_group_ingress_rules>
    
    provider_region = "${var.default_region}"
    # assume_role_arn = arn:aws:iam::123456789012:role/AnotherRole # Assume 'AnotherRole' to create security group
}
```

##### Example Output
```bash
+ module.security_group_webserver.aws_security_group.security_group
    description: "desctiption of your security group"
    egress.#:    "<computed>"
    ingress.#:   "<computed>"
    name:        "name_of_your_security_group"
    owner_id:    "<computed>"
    tags.%:      "1"
    tags.Name:   "name_of_your_security_group"
    vpc_id:      "${var.vpc_id}"

+ module.security_group_webserver.aws_security_group_rule.cidr_ingress_rule.0
    cidr_blocks.#:            "2"
    cidr_blocks.0:            "your.ip.address.here/32"
    cidr_blocks.1:            "your.second.ip.address/32"
    from_port:                "80"
    protocol:                 "tcp"
    security_group_id:        "${aws_security_group.security_group.id}"
    self:                     "false"
    source_security_group_id: "<computed>"
    to_port:                  "80"
    type:                     "ingress"

+ module.security_group_webserver.aws_security_group_rule.cidr_ingress_rule.1
    cidr_blocks.#:            "2"
    cidr_blocks.0:            "your.ip.address.here/32"
    cidr_blocks.1:            "your.second.ip.address/32"
    from_port:                "443"
    protocol:                 "tcp"
    security_group_id:        "${aws_security_group.security_group.id}"
    self:                     "false"
    source_security_group_id: "<computed>"
    to_port:                  "443"
    type:                     "ingress"

+ module.security_group_webserver.aws_security_group_rule.cidr_ingress_rule.2
    cidr_blocks.#:            "1"
    cidr_blocks.0:            "0.0.0.0/0"
    from_port:                "22"
    protocol:                 "tcp"
    security_group_id:        "${aws_security_group.security_group.id}"
    self:                     "false"
    source_security_group_id: "<computed>"
    to_port:                  "22"
    type:                     "ingress"

+ module.security_group_webserver.aws_security_group_rule.sg_ingress_rule
    from_port:                "6379"
    protocol:                 "tcp"
    security_group_id:        "${aws_security_group.security_group.id}"
    self:                     "false"
    source_security_group_id: "${element(split(\",\", var.security_group_ingress_rules[\"source_security_groups\"]), count.index) == \"self\" ? aws_security_group.security_group.id : element(split(\",\", var.security_group_ingress_rules[\"source_security_groups\"]), count.index)}"
    to_port:                  "6379"
    type:                     "ingress"

```
