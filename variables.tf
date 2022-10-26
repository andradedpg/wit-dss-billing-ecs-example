variable "ENVIRONMENT" {
  type        = string
  description = "Environment name"
}
variable "PROJECT" {
  type        = string
  description = "Name of Project"
}
variable "VPC_CIDR" {
  type        = string
  description = "CIDR range of vpc Ips"
}
variable "PUBLIC_SUBNETS" {
  type        = list(string)
  description = "List of public subnets"
}
variable "PRIVATE_SUBNETS" {
  type        = list(string)
  description = "List of private subnets"
}

variable "ECS_EC2_AMI_ID" {
  type        = string
  description = "ID AMI of EC2 Instance requested"
}

variable "ECS_EC2_INSTANCE_TYPE" {
  type        = string
  description = "EC2 Instance type requested"
}

variable "CLUSTER_SIZE" {
  type = any
  description = "Min, max and desired values of ECS cluster workdernodes"
}

# variable "ECR_REPOSITORIES" {
#   type = object({
#     nginx = string
#     ruby  = string
#   })

#   description = "Name of repositories"
# }
# variable "SECRET_MANAGER_NAME" {
#   type        = string
#   description = "Name of SecretManager resource"
# }
# ##GitHub Connect
# variable "GH_THUMBPRINT" {
#   type        = string
#   description = "Thumbprint of GH Actions OIDC Provider"
# }
# variable "GH_ORG_NAME" {
#   type        = string
#   description = "Github organization name"
# }
# variable "GH_ORG_REPO_NAME" {
#   type        = string
#   description = "Github repository name"
# }
# variable "GH_ORG_BRANCH_NAME" {
#   type        = string
#   description = "Github repository name"
# }


# variable "ECS_EC2_SPOT_INSTANCE_TYPE" {
#   type        = string
#   description = "Type of EC2 SPOT Instance requested"
# }

# variable "ALLOWED_TRAFFIC" {
#   type = list(object({
#     type       = string
#     cidr_block = list(string)
#     port_from  = number
#     port_to    = number
#     protocol   = string
#   }))
#   description = "Type of EC2 SPOT Instance requested"
# }

# variable "ROUTE53_ZONE_NAME" {
#   type        = string
#   description = "Name of Route53 zone"
# }

# variable "DOMAIN_NAME" {
#   type        = string
#   description = "Name of domain"
# }

# variable "SUBDOMAIN_API_NAME" {
#   type        = string
#   description = "Name of subdomain for API"
#   default     = "api"
# }

# variable "SCHEDULE_ENABLED" {
#   description = "Schedule EC2 is enabled"
# }

# variable "CLOUDFRONT_ENABLED" {
#   description = "Enable CloudFront"
# }

# variable "PROJECT_PATH" {
#   description = "Path of project"
# }
# variable "SECUTIRY_GROUP_NAME" {
#   description = "SECUTIRY_GROUP_NAME"
#   default     = ""
# }