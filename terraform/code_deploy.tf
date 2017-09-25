resource "aws_codedeploy_app" "wordpress_app" {
  name = "wordpress"
}

resource "aws_iam_role" "wordpress_role" {
  name = "wordpress_cd_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "wordpress_policy" {
  name = "wordpress_cd_policy"
  role = "${aws_iam_role.wordpress_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:DeleteLifecycleHook",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLifecycleHooks",
                "autoscaling:PutLifecycleHook",
                "autoscaling:RecordLifecycleActionHeartbeat",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "tag:GetTags",
                "tag:GetResources"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_codedeploy_deployment_config" "wordpress_config" {
  deployment_config_name = "wordpress_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = "${aws_codedeploy_app.wordpress_app.name}"
  deployment_group_name = "Wordpress_Group"
  service_role_arn      = "${aws_iam_role.wordpress_role.arn}"
  deployment_config_name = "${aws_codedeploy_deployment_config.wordpress_config.id}"
  autoscaling_groups = ["${aws_autoscaling_group.ec2.id}"]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}


