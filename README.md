# ECS POC with Spot and OnDemand Instances



First, install Terraform:
https://learn.hashicorp.com/tutorials/terraform/install-cli

...and make sure that you have the right permissions inside AWS to create needed resources.

##### Init the environment

```
$ cd wit-dss-billing-ecs-example/
```

```
$ terraform init
```

##### See plan create/update of environment

```
$ terraform plan -var-file=./envs/test.tfvars
```

##### Aplly infrastructure in environment

```
$ terraform apply -var-file=./envs/test.tfvars -auto-approve
```

##### Destroy environment

```
$ terraform destroy -var-file=./envs/test.tfvars 
```