# Launch configuration for Wordpress
resource "aws_launch_configuration" "ec2" {
  name                 = "ecs-configuration"
  instance_type        = "${var.instance_type}"
  image_id             = "${var.ami}"
  security_groups      = ["${aws_security_group.ecs.id}", "${aws_security_group.ec2_egress.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "${data.template_file.ec2_userdata.rendered}"
  key_name             = "${var.keypair}"
}

# We need this 'depend_on' line otherwise we may not be able to reach internet at first terraform apply command
resource "aws_autoscaling_group" "ec2" {
  lifecycle {
     create_before_destroy = "True"
  }
  depends_on           = ["aws_nat_gateway.natgw_zoneA", "aws_nat_gateway.natgw_zoneB"]
  name                 = "ecs-autoscale"
  vpc_zone_identifier  = ["${aws_subnet.private_subnet_zoneA.id}", "${aws_subnet.private_subnet_zoneB.id}"]
  launch_configuration = "${aws_launch_configuration.ec2.name}"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  load_balancers       = ["${aws_elb.ec2.name}"]
  tag {
        key = "Name"
        value = "Wordpress"
        propagate_at_launch = true
  }
}

# Load Balancer for the ec2 instances
resource "aws_elb" "ec2" {
  name               = "wordpress-elb"
  security_groups    = ["${aws_security_group.ecs.id}", "${aws_security_group.elb.id}"]
  subnets            = ["${aws_subnet.public_subnet_zoneA.id}", "${aws_subnet.public_subnet_zoneB.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-admin/install.php"
    interval            = 30
  }
}

data "template_file" "ec2_userdata" {
  template = "${file("userdata.sh")}"
  vars {
    rds_username = "${var.rds_username}"
    rds_password = "${var.rds_password}"
    rds_db_name = "${var.rds_db_name}"
    rds_db_host = "${aws_db_instance.rds.address}"
    nfs_fqdn    = "${aws_efs_mount_target.efs_private_zoneA.dns_name}"
  }
}
