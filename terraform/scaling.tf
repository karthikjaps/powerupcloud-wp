#Scaling policies with CPU load
resource "aws_autoscaling_policy" "wordpresspolicy" {
  name                   = "wordpress-policy-high"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ec2.name}"
}

resource "aws_autoscaling_policy" "wordpresspolicylow" {
  name                   = "wordpress-policy-low"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ec2.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpuhigh" {
  alarm_name          = "wordpress-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ec2.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.wordpresspolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cpulow" {
  alarm_name          = "wordpress-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ec2.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.wordpresspolicylow.arn}"]
}