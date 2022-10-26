resource "aws_ecs_cluster" "cluster" {
  name = "${var.PROJECT}-cluster"

   tags = merge(
    local.tags,
    {
      "Propose" = "ECS Cluster",
      "Name"    = "${var.PROJECT}-ECS Cluster"
    }
  )

}

# resource "aws_ecs_cluster_capacity_providers" "cluster_capacities" {
#   cluster_name = aws_ecs_cluster.cluster.name

#   capacity_providers = [aws_ecs_capacity_provider.spot_capacity.name]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = aws_ecs_capacity_provider.example.name
#   }
# }

# resource "aws_ecs_capacity_provider" "spot_capacity" {
#   name = "${var.PROJECT}-ecs-spot-capacity"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.ecs_asg_spot_group.arn
#   }
# }

# resource "aws_ecs_capacity_provider" "on_demand_capacity" {
#   name = "${var.PROJECT}-ecs-spot-capacity"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.ecs_asg_spot_group.arn
#   }
# }