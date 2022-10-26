resource "aws_autoscaling_schedule" "on_week" {
  scheduled_action_name  = "on_instance_week"
  min_size               = var.CLUSTER_SIZE.ECS_OND_MIN
  max_size               = var.CLUSTER_SIZE.ECS_OND_MAX
  desired_capacity       = var.CLUSTER_SIZE.ECS_OND_DES
  start_time             = timeadd(timestamp(), "2m")
  recurrence             = "0 9 * * MON-FRI"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name
  lifecycle {
    ignore_changes = [start_time]
  }
}
resource "aws_autoscaling_schedule" "off_sat" {
  scheduled_action_name  = "off_instance_sat"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  start_time             = timeadd(timestamp(), "3m")
  recurrence             = "0 23 * * SAT"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "aws_autoscaling_schedule" "on_sat" {
  scheduled_action_name  = "on_instance_sat"
  min_size               = var.CLUSTER_SIZE.ECS_OND_MIN
  max_size               = var.CLUSTER_SIZE.ECS_OND_MAX
  desired_capacity       = var.CLUSTER_SIZE.ECS_OND_DES
  start_time             = timeadd(timestamp(), "4m")
  recurrence             = "0 11 * * MON-FRI"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name
  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "aws_autoscaling_schedule" "off_sun" {
  scheduled_action_name  = "off_instance_sun"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  start_time             = timeadd(timestamp(), "5m")
  recurrence             = "0 21 * * SUN"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "aws_autoscaling_schedule" "on_sun" {
  scheduled_action_name  = "on_instance_sun"
  min_size               = var.CLUSTER_SIZE.ECS_OND_MIN
  max_size               = var.CLUSTER_SIZE.ECS_OND_MAX
  desired_capacity       = var.CLUSTER_SIZE.ECS_OND_DES
  start_time             = timeadd(timestamp(), "6m")
  recurrence             = "0 11 * * SUN"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name
  lifecycle {
    ignore_changes = [start_time]
  }
}