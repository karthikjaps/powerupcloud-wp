#Public network Zone 1
resource "aws_subnet" "public_subnet_zoneA" {
  vpc_id = "${aws_vpc.vpc_wordpress.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "10.0.0.0/24"
}
#Public network Zone 2
resource "aws_subnet" "public_subnet_zoneB" {
  vpc_id = "${aws_vpc.vpc_wordpress.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "10.0.1.0/24"
}
#Private network Zone 1
resource "aws_subnet" "private_subnet_zoneA" {
  vpc_id = "${aws_vpc.vpc_wordpress.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "10.0.10.0/24"
}
#Private network Zone 2
resource "aws_subnet" "private_subnet_zoneB" {
  vpc_id = "${aws_vpc.vpc_wordpress.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "10.0.11.0/24"
}
