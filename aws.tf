# Terraform aws entry point , given access, secrete key and region
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region  = "${var.region}"
}

# Available zones in that region

data "aws_availability_zones" "available" {}

# Store terraform state in S3

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config {
    bucket     = "${var.s3_bucket}"
    region     = "${var.region}"
    key        = "terraform.tfstate"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  }
}
