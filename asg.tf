resource "aws_autoscaling_group" "ecs_asg_spot_group" {
  name                      = "${var.PROJECT}-${var.ENVIRONMENT}-asg-spot"
  max_size                  = var.CLUSTER_SIZE.ECS_SPOT_MAX
  min_size                  = var.CLUSTER_SIZE.ECS_SPOT_MIN
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.CLUSTER_SIZE.ECS_SPOT_DES
  force_delete              = true
  vpc_zone_identifier       = aws_subnet.private_subnet[*].id

  depends_on = [
    aws_launch_template.cluster_ec2_spot_config
  ]

  launch_template {
    id      = aws_launch_template.cluster_ec2_spot_config.id
    version = "$Latest"
  }
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "${var.PROJECT}-${var.ENVIRONMENT}"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonEC2Managed"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
  }
}

resource "aws_autoscaling_group" "ecs_asg_ondemand_group" {
  name                      = "${var.PROJECT}-${var.ENVIRONMENT}-asg-on-demand"
  max_size                  = var.CLUSTER_SIZE.ECS_OND_MAX
  min_size                  = var.CLUSTER_SIZE.ECS_OND_MIN
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.CLUSTER_SIZE.ECS_OND_DES
  force_delete              = true
  vpc_zone_identifier       = aws_subnet.private_subnet[*].id

  depends_on = [
    aws_launch_template.cluster_ec2_ondemand_config
  ]

  launch_template {
    id      = aws_launch_template.cluster_ec2_ondemand_config.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.PROJECT}-${var.ENVIRONMENT}"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonEC2Managed"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
  }
}
