# All variables defined here
# define the local IP to map to the SSH security rule
variable "local_ip" {
  type = "string"
}

# pass the region as a variable so we can provide it in a tfvars file
variable "region" {
  type = "string"
}

# pass the keypair as a variable so we can provide it in a tfvars file
variable "keypair" {
  type = "string"
}

# pass the aws access key as a variable so we can provide it in a tfvars file
variable "aws_access_key" {
  type = "string"
}

# pass the aws secret key as a variable so we can provide it in a tfvars file
variable "aws_secret_key" {
  type = "string"
}
# Rds Related variables username
variable "rds_username" {
  type = "string"
}
# Rds Related variables password
variable "rds_password" {
  type = "string"
}
# Rds Related variables dbname
variable "rds_db_name" {
  type = "string"
}

#S3 bucket where remote state and Jenkins data will be stored.
variable "s3_bucket" {
  default = "terraform-state.wordpress"
  description = "S3 bucket where remote state and Jenkins data will be stored."
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_class" {
  default = "t2.micro"
}

# define the region specific wordpress images
variable "wordpress-images" {
  type = "map"

  default = {
    "us-east-1" = "ami-ff6c7384"
  }
}

variable "zones" {
  type = "map"

  default = {
    "us-east-1" = "us-east-1b"
  }
}

variable "ami" {
  default = "ami-9eb4b1e5"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server."
  default = "jenkins"
}