provider "aws" {
    alias = "module"
    region = "${var.provider_region}"
    profile = "${var.profile}"
    assume_role {
        role_arn = "${var.assume_role_arn}"
    }
}
