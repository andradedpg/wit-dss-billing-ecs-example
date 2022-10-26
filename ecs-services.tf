resource "aws_ecs_task_definition" "nginx_definition" {
  family = "nginx"
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 1000
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  tags = merge(
    local.tags,
    {
      "Propose" = "Task of Nginx service",
      "Name"    = "${var.PROJECT}-ECS Cluster - Nginx Service"
    }
  )

  depends_on = [
    aws_ecs_cluster.cluster
  ]
}

resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.nginx_definition.id
  iam_role        = aws_iam_role.ecs_task_service_role.arn 
  desired_count   = 1

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_http.arn
    container_name   = "nginx"
    container_port   = 80
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }

  depends_on = [
    aws_ecs_cluster.cluster, 
    aws_ecs_task_definition.nginx_definition
  ]
}