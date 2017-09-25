# Jenkins Configuration

data "template_file" "jenkins_userdata" {
  template = "${file("jenkins_userdata.sh")}"
  vars {
    region = "${var.region}"
    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
  }
}

resource "aws_instance" "jenkins" {
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
  ami = "${var.ami}"
  subnet_id = "${aws_subnet.public_subnet_zoneA.id}"
  key_name = "${var.keypair}"
  user_data = "${data.template_file.jenkins_userdata.rendered}"
  associate_public_ip_address = "True"

  tags {
    "Name" = "${var.jenkins_name}"
  }
}