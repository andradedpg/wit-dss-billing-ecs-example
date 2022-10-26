# VPC
ENVIRONMENT         = "dss-test"
PROJECT             = "POC-ECS-Spot-OnDemand"
VPC_CIDR            = "10.0.0.0/20"
PUBLIC_SUBNETS      = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"]
PRIVATE_SUBNETS     = ["10.0.6.0/23", "10.0.8.0/23", "10.0.10.0/23"]
# ECS
ECS_EC2_AMI_ID         = "ami-00eb90638788e810f" # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html 
ECS_EC2_INSTANCE_TYPE  = "t3a.medium"
# Cluster - workernodes sizes
CLUSTER_SIZE = {
    "ECS_SPOT_MIN" : 1,
    "ECS_SPOT_MAX" : 5,
    "ECS_SPOT_DES" : 2,

    "ECS_OND_MIN"  : 0,
    "ECS_OND_MAX"  : 5,
    "ECS_OND_DES"  : 1
}