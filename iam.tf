resource "aws_iam_role" "ecs_ec2_instance_role" {
  name = "ecs-${var.PROJECT}-${var.ENVIRONMENT}-ec2-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}
resource "aws_iam_role" "ecs_task_service_role" {
  name = "ecs-${var.PROJECT}-${var.ENVIRONMENT}-task-service-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ecs.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ecs_ec2_instance_role_policy" {
  name        = "ecs-${var.PROJECT}-${var.ENVIRONMENT}-ec2-instance-role-policy"
  path        = "/"
  description = "Policy for ECS EC2 Nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "ecs:StartTelemetrySession",
          "ecs:RegisterContainerInstance",
          "ecs:Poll",
          "ecs:DiscoverPollEndpoint",
          "ecs:DeregisterContainerInstance",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ec2:DescribeTags",
          "ec2:DescribeAddresses",
          "ec2:AllocateAddress",
          "ec2:DescribeInstances",
          "ec2:AssociateAddress",
          "opsworks:DisassociateElasticIp"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_instance_role_policy_attachment" {
  role       = aws_iam_role.ecs_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "ecs_ec2_instance_role_policy_attachment_owned" {
  role       = aws_iam_role.ecs_ec2_instance_role.name
  policy_arn = aws_iam_policy.ecs_ec2_instance_role_policy.arn
}
resource "aws_iam_role_policy_attachment" "ecs_ec2_task_service_policy_attachment" {
  role       = aws_iam_role.ecs_task_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_instance_profile" "ecs_ec2_instance_profile" {
  name = "ecs-${var.PROJECT}-${var.ENVIRONMENT}-ec2-instance-profile"
  role = aws_iam_role.ecs_ec2_instance_role.name
}