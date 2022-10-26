data "aws_availability_zones" "available" {
  state = "available"
}
  
locals {
  availability_zones = data.aws_availability_zones.available.names

  tags = {
    Environment = var.ENVIRONMENT
    Project     = var.PROJECT
    ManagedBy   = "Terraform"
    Maintener   = "WIT DSS ECS Demo"
  }

}