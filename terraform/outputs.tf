# Result of terraform exicution in AWS
output "rds_host" {
  value = "${aws_db_instance.rds.address}"
}

output "wordpress_domain" {
  value = "${aws_elb.ec2.dns_name}"
}

output "jenkins_public_dns" {
  value = "[ ${aws_instance.jenkins.public_dns} ]"
}
