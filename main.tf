locals {
  common_tags = {
    Project   = "${var.name_prefix}-${var.service_name}-${var.env}"
    ManagedBy = "Terraform"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_ecr_authorization_token" "token" {}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
  required_version = ">= 0.13"
}
