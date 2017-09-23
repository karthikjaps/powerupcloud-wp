# Wordpress Database configuration
resource "aws_db_instance" "rds" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.6.27"
  identifier           = "wpdb"
  instance_class       = "${var.instance_class}"
  name                 = "${var.rds_db_name}"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds.name}"
  final_snapshot_identifier = "finalsnapshot"
  skip_final_snapshot = "true"
  vpc_security_group_ids   = ["${aws_security_group.rds.id}"]
}

resource "aws_db_subnet_group" "rds" {
  name       = "subnet_group"
  subnet_ids = ["${aws_subnet.private_subnet_zoneA.id}", "${aws_subnet.private_subnet_zoneB.id}"]
}
