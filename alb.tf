resource "aws_lb" "loadbalancer" {
  name                       = "${var.PROJECT}-${var.ENVIRONMENT}"
  load_balancer_type         = "application"
  internal                   = false
  subnets                    = aws_subnet.public_subnet[*].id
  security_groups            = [aws_security_group.ecs_ec2_access_sg.id]

  tags = merge(
    local.tags,
    {
      "Propose" = "ALB for ECS Cluster",
      "Name"    = "${var.PROJECT}-ALB"
    }
  )

  depends_on = [
    aws_vpc.vpc, 
    aws_autoscaling_group.ecs_asg_ondemand_group,
    aws_autoscaling_group.ecs_asg_spot_group
  ]
}

resource "aws_lb_target_group" "target_group_http" {
  name       = "${var.PROJECT}-tg-http-01"
  
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id

  depends_on = [
    aws_lb.loadbalancer
  ]

  tags = merge(
    local.tags,
    {
      "Propose" = "HTTP TargetGroup for ALB",
      "Name"    = "${var.PROJECT}-TG-HTTP"
    }
  )
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_http.arn
  }

  depends_on = [
    aws_lb_target_group.target_group_http
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_to_ondemand" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_ondemand_group.name
  lb_target_group_arn    = aws_lb_target_group.target_group_http.arn
}

resource "aws_autoscaling_attachment" "asg_attachment_to_spot" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg_spot_group.name
  lb_target_group_arn    = aws_lb_target_group.target_group_http.arn
}