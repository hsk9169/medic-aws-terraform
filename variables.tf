variable "env" {
  type        = string
  description = "environment of service deployment"
}

variable "aws_region" {
  type        = string
  description = "region name of the vpc"
  default     = "ap-northeast-2"
}

variable "az_count" {
  type        = number
  description = "Number of AZs to cover in a given region"
  default     = 2
}

variable "name_prefix" {
  type        = string
  description = "name prefix of the project"
  default     = "tf"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "service_name" {
  type        = string
  description = "fargate cluster service name"
  default     = "medic"
}

variable "service_port_main" {
  type        = number
  description = "main service port number"
  default     = 8080
}

variable "service_port_sub" {
  type        = number
  description = "sub service port number"
  default     = 80
}

variable "secret_port" {
  type        = number
  description = "https port"
  default     = 443
}

variable "ssh_port" {
  type        = number
  description = "secured shell port number"
  default     = 22
}

variable "mysql_port" {
  type        = number
  description = "mysql for hospital list info"
  default     = 3306
}

variable "container_count" {
  type        = number
  description = "Number of docker containers to run"
  default     = 2
}

variable "autoscaling_min_count" {
  type    = number
  default = 1
}

variable "autoscaling_max_count" {
  type    = number
  default = 1
}

variable "health_check_path" {
  type    = string
  default = "/health/ready"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "dynamodb_table_name" {
  description = "table name for Dynamo table"
  default     = "dev-socket-app-terraform-state-lock"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the API Gateway endpoint"
  default     = "illzy.com"
}

variable "route53_subdomain" {
  type        = string
  description = "subdomain name which API gateway will use for custom domain setup. Needs to match the ACM SSL"
  default     = "medic-api"
}

#variable "domain_name_certificate_arn" {
#  type        = string
#  description = "The ACM certificate ARN to use for the api gateway"
#}
