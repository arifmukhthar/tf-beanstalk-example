provider "aws" {
  region  = var.aws_region
  profile = var.aws_target_profile
}

variable "aws_target_profile" {}
variable "aws_region" {}
variable "bc_cidr" {}
variable "bc_name" {}
variable "bc_env" {}
variable "component" {}
variable "bc_app_name" {}
variable "instance_type" {}
variable "application_healthcheck_url" {}
variable "service_endpoint_url" {}
variable "beanstalk_environment_variables" { type = map }
variable "autoscaling_nodes_min" {}
variable "autoscaling_nodes_max" {}

module "vpc" {
  source      = "git::ssh://git@github.com/arifmukhthar/tf-module-vpc.git?ref=main"
  bc_vpc_cidr = var.bc_cidr
  bc_name     = var.bc_name
  bc_env      = var.bc_env
  bc_region   = var.aws_region
  component   = var.component
}
output "vpc" {
  value = module.vpc
}

module "beanstalk" {
  source                          = "git::ssh://git@github.com/arifmukhthar/tf-module-beanstalk.git?ref=main"
  bc_name                         = var.bc_name
  bc_env                          = var.bc_env
  bc_app_name                     = var.bc_app_name
  vpc_id                          = module.vpc["vpc_id"]
  ec2_subnet_id                   = [for priv_subnet in module.vpc["subnets_priv_ids"] : priv_subnet]
  elb_subnet_id                   = [for pub_subnet in module.vpc["subnets_pub_ids"] : pub_subnet]
  component_name                  = var.component
  instance_type                   = var.instance_type
  application_healthcheck_url     = var.application_healthcheck_url
  service_endpoint_url            = var.service_endpoint_url
  beanstalk_environment_variables = var.beanstalk_environment_variables
  autoscaling_nodes_min           = var.autoscaling_nodes_min
  autoscaling_nodes_max           = var.autoscaling_nodes_max 
}

output "beanstalk" {
  value = module.beanstalk
}