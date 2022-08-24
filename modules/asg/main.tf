resource "aws_launch_configuration" "aws_autoscale_conf" {
  name          = "web_config"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  user_data     = var.user_data
  key_name      = aws_key_pair.asg_key.key_name
}

resource "aws_autoscaling_group" "mygroup" {
  availability_zones        = [var.az]
  name                      = "autoscalegroup"
  health_check_type         = "ELB"
  load_balancers            = ["${aws_lb.web_elb.id}"]
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 30
  #health_check_type         = "EC2"
  force_delete         = true
  termination_policies = ["OldestInstance"]
  launch_configuration = aws_launch_configuration.aws_autoscale_conf.name
}

resource "aws_autoscaling_schedule" "mygroup_schedule" {
  scheduled_action_name  = "autoscalegroup_action"
  min_size               = 2
  max_size               = 3
  desired_capacity       = 2
  start_time             = "2022-09-09T18:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.mygroup.name
}

resource "aws_autoscaling_policy" "mygroup_policy" {
  name                   = "autoscalegroup_policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.mygroup.name
}
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  alarm_actions = [
    "${aws_autoscaling_policy.mygroup_policy.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.mygroup.name}"
  }
}

resource "aws_key_pair" "asg_key" {
  public_key = var.public_key
}

resource "aws_lb" "web_elb" {
  name               = "web-elb"
  security_groups    = var.security_groups
  subnets            = [var.subnet]
  load_balancer_type = "application"
  #   health_check {
  #     healthy_threshold   = 2
  #     unhealthy_threshold = 2
  #     timeout             = 3
  #     interval            = 30
  #     target              = "HTTP:80/"
  #   }
  #   listener {
  #     lb_port           = 80
  #     lb_protocol       = "http"
  #     instance_port     = "80"
  #     instance_protocol = "http"
  #   }
}