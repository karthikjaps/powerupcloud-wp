# Security Group for ECS for allow port 80 from public
resource "aws_security_group" "ecs" {
  tags {
        Name = "sg-wordpress-ecs"
  }
  name = "http"
  vpc_id      = "${aws_vpc.vpc_wordpress.id}"
  description = "Allow http port for wordpress containers"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.local_ip}/32"]
  }
}

# Security Group for EC2 egress port 80 HTTP,443 HTTPS,2049 EFS,3306 MySQL
resource "aws_security_group" "ec2_egress" {
  tags {
        Name = "sg-wordpress-ec2"
  }
  name = "ec2_egress"
  vpc_id      = "${aws_vpc.vpc_wordpress.id}"
  description = "Every needed rules for the ec2 instances (nfs, mysql, http/S for yum install)"
  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = ["${aws_subnet.private_subnet_zoneA.cidr_block}", "${aws_subnet.private_subnet_zoneB.cidr_block}"]
  }
  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["${aws_subnet.private_subnet_zoneA.cidr_block}", "${aws_subnet.private_subnet_zoneB.cidr_block}"]
  }
}
# Security Group for LoadBalancer egress port 80 HTTP

resource "aws_security_group" "elb" {
  tags {
        Name = "sg-wordpress-elb"
  }
  name = "http-egress"
  vpc_id      = "${aws_vpc.vpc_wordpress.id}"
  description = "Allow http from elb to ecs instances"
  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${aws_subnet.private_subnet_zoneA.cidr_block}", "${aws_subnet.private_subnet_zoneB.cidr_block}"]
  }
}

# Security Group for RDS egress port 3306 MySQL

resource "aws_security_group" "rds" {
  tags {
        Name = "sg-wordpress-rds"
  }
  name        = "mysql"
  vpc_id      = "${aws_vpc.vpc_wordpress.id}"
  description = "Allow mysql port"
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["${aws_subnet.private_subnet_zoneA.cidr_block}", "${aws_subnet.private_subnet_zoneB.cidr_block}"]
  }
}
# Security Group for efs egress port 2049

resource "aws_security_group" "efs" {
  tags {
        Name = "sg-wordpress-efs"
  }
  name              = "nfs"
  vpc_id            = "${aws_vpc.vpc_wordpress.id}"
  description       = "Allow nfs port"
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks     = ["${aws_subnet.private_subnet_zoneA.cidr_block}", "${aws_subnet.private_subnet_zoneB.cidr_block}"]
  }
}

# Security Group for Jenkins
resource "aws_security_group" "sg_jenkins" {
  name = "jenkins"
  description = "Allows jenkins traffic"
  vpc_id = "${aws_vpc.vpc_wordpress.id}"

  tags {
        Name = "jenkins-traffic"
        Project = "wordpress"
  }

  # SSH allowed only myself
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.local_ip}/32"]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Jenkins JNLP port
  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}