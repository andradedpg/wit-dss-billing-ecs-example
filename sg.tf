resource "aws_security_group" "ecs_ec2_access_sg" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-default-ecs"
  description = "Allow traffic to ec2 instances"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-${var.ENVIRONMENT}-default-ecs"
    }
  )
}

resource "aws_security_group_rule" "traffic_in_ecs_ec2_http" {
  type              = "ingress"
  description       = "Allow igress HTTP"
  protocol          = "TCP"
  security_group_id = aws_security_group.ecs_ec2_access_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
}
resource "aws_security_group_rule" "traffic_in_ecs_ec2_https" {
  type              = "ingress"
  description       = "Allow igress HTTP"
  protocol          = "TCP"
  security_group_id = aws_security_group.ecs_ec2_access_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}
resource "aws_security_group_rule" "traffic_in_ecs_ec2_self" {
  type              = "ingress"
  description       = "Allow igress self"
  protocol          = "all"
  security_group_id = aws_security_group.ecs_ec2_access_sg.id
  self              = true
  from_port         = 0
  to_port           = 0
}
resource "aws_security_group_rule" "traffic_out_ecs_ec2_https" {
  type              = "egress"
  description       = "Allow egress all"
  protocol          = "all"
  security_group_id = aws_security_group.ecs_ec2_access_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}