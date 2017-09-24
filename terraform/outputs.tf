# Result of terraform exicution in AWS
output "ecr_repository" {
  value = "${aws_ecr_repository.ecr.repository_url}"
}

output "rds_host" {
  value = "${aws_db_instance.rds.address}"
}

output "elb_dns" {
  value = "${aws_elb.ec2.dns_name}"
}

output "jenkins_public_dns" {
  value = "[ ${aws_instance.jenkins.public_dns} ]"
}
