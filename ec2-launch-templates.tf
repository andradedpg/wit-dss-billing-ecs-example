resource "aws_launch_template" "cluster_ec2_spot_config" {
  name                   = "${var.PROJECT}-${var.ENVIRONMENT}-spot-config"
  image_id               = var.ECS_EC2_AMI_ID
  instance_type          = var.ECS_EC2_INSTANCE_TYPE
  update_default_version = true

  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized           = true

  instance_initiated_shutdown_behavior = "terminate"
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      # block_duration_minutes = 60
      instance_interruption_behavior = "terminate"
      spot_instance_type             = "one-time"
    }
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_instance_profile.name
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"

    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      "Name"    = "${var.PROJECT}-${var.ENVIRONMENT}-spot-instance-node"
      "Propose" = "WorkerNode for ECS cluster for ${var.PROJECT}"
      "Pricing" = "SPOT"
    })
  }

  depends_on = [
    aws_vpc.vpc
  ]

  user_data = base64encode(templatefile("${path.module}/utils/workernode-userdata.tpl", {
    LAUNCHTIME         = "${timestamp()}",
    ECS_CLUSTER_NAME   = "${aws_ecs_cluster.cluster.name}"
  }))
}

resource "aws_launch_template" "cluster_ec2_ondemand_config" {
  name                   = "${var.PROJECT}-${var.ENVIRONMENT}-ondemand-config"
  image_id               = var.ECS_EC2_AMI_ID
  instance_type          = var.ECS_EC2_INSTANCE_TYPE
  update_default_version = true

  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized           = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_instance_profile.name
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"

    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      "Name"    = "${var.PROJECT}-${var.ENVIRONMENT}-ondemand-instance-node"
      "Propose" = "WorkerNode for ECS cluster for ${var.PROJECT}", 
      "Pricing" = "OnDemand"
    })
  }

  depends_on = [
    aws_vpc.vpc
  ]

  user_data = base64encode(templatefile("${path.module}/utils/workernode-userdata.tpl", {
    LAUNCHTIME         = "${timestamp()}",
    ECS_CLUSTER_NAME   = "${aws_ecs_cluster.cluster.name}"
  }))
}