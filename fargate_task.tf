locals {
  aws_account_id       = data.aws_caller_identity.current.account_id
  service_namespace_id = aws_service_discovery_private_dns_namespace.app.id
  basic_api_task_image = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.name_prefix}-${var.service_name}-${var.env}-basic-api:latest"
  s3_api_task_image    = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.name_prefix}-${var.service_name}-${var.env}-s3-api:latest"
  auth_api_task_image  = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.name_prefix}-${var.service_name}-${var.env}-auth-api:latest"
  crawler_task_image   = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.name_prefix}-${var.service_name}-${var.env}-crawler:latest"
  basic_api_log_group  = "/${var.name_prefix}-${var.service_name}-${var.env}-basic-api/log"
  s3_api_log_group     = "/${var.name_prefix}-${var.service_name}-${var.env}-s3-api/log"
  auth_api_log_group   = "/${var.name_prefix}-${var.service_name}-${var.env}-auth-api/log"
  crawler_log_group    = "/${var.name_prefix}-${var.service_name}-${var.env}-crawler/log"
}

locals {
  basic_api_container_definition = {
    cpu         = 512
    image       = local.basic_api_task_image
    memory      = 1024
    name        = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api"
    networkMode = "awsvpc"
    environment = [
      {
        "name" : "SERVICE_DISCOVERY_NAMESPACE_ID", "value" : local.service_namespace_id
      }
    ]
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.service_port_main
        hostPort      = var.service_port_main
      }
    ]
    logConfiguration = {
      logdriver = "awslogs"
      options = {
        "awslogs-group"         = local.basic_api_log_group
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "stdout"
      }
    }
  }
  s3_api_container_definition = {
    cpu         = 512
    image       = local.s3_api_task_image
    memory      = 1024
    name        = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api"
    networkMode = "awsvpc"
    environment = [
      {
        "name" : "SERVICE_DISCOVERY_NAMESPACE_ID", "value" : local.service_namespace_id
      }
    ]
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.service_port_main
        hostPort      = var.service_port_main
      }
    ]
    logConfiguration = {
      logdriver = "awslogs"
      options = {
        "awslogs-group"         = local.s3_api_log_group
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "stdout"
      }
    }
  }
  auth_api_container_definition = {
    cpu         = 512
    image       = local.auth_api_task_image
    memory      = 1024
    name        = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api"
    networkMode = "awsvpc"
    environment = [
      {
        "name" : "SERVICE_DISCOVERY_NAMESPACE_ID", "value" : local.service_namespace_id
      }
    ]
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.service_port_main
        hostPort      = var.service_port_main
      }
    ]
    logConfiguration = {
      logdriver = "awslogs"
      options = {
        "awslogs-group"         = local.auth_api_log_group
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "stdout"
      }
    }
  }
  crawler_container_definition = {
    cpu         = 512
    image       = local.crawler_task_image
    memory      = 1024
    name        = "${var.name_prefix}-${var.service_name}-${var.env}-crawler"
    networkMode = "awsvpc"
    environment = [
      {
        "name" : "SERVICE_DISCOVERY_NAMESPACE_ID", "value" : local.service_namespace_id
      }
    ]
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.service_port_main
        hostPort      = var.service_port_main
      }
    ]
    logConfiguration = {
      logdriver = "awslogs"
      options = {
        "awslogs-group"         = local.crawler_log_group
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "stdout"
      }
    }
  }
}

resource "aws_ecs_task_definition" "basic_api" {
  family                   = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api-task"
  network_mode             = "awsvpc"
  cpu                      = local.basic_api_container_definition.cpu
  memory                   = local.basic_api_container_definition.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode([local.basic_api_container_definition])
  execution_role_arn       = aws_iam_role.basicApi-fargate_execution.arn
  task_role_arn            = aws_iam_role.basicApi-fargate_task.arn
}

resource "aws_ecs_task_definition" "s3_api" {
  family                   = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api-task"
  network_mode             = "awsvpc"
  cpu                      = local.s3_api_container_definition.cpu
  memory                   = local.s3_api_container_definition.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode([local.s3_api_container_definition])
  execution_role_arn       = aws_iam_role.s3Api-fargate_execution.arn
  task_role_arn            = aws_iam_role.s3Api-fargate_task.arn
}

resource "aws_ecs_task_definition" "auth_api" {
  family                   = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api-task"
  network_mode             = "awsvpc"
  cpu                      = local.auth_api_container_definition.cpu
  memory                   = local.auth_api_container_definition.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode([local.auth_api_container_definition])
  execution_role_arn       = aws_iam_role.authApi-fargate_execution.arn
  task_role_arn            = aws_iam_role.authApi-fargate_task.arn
}

resource "aws_ecs_task_definition" "crawler" {
  family                   = "${var.name_prefix}-${var.service_name}-${var.env}-crawler-task"
  network_mode             = "awsvpc"
  cpu                      = local.crawler_container_definition.cpu
  memory                   = local.crawler_container_definition.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode([local.crawler_container_definition])
  execution_role_arn       = aws_iam_role.crawler-fargate_execution.arn
  task_role_arn            = aws_iam_role.crawler-fargate_task.arn
}

resource "aws_cloudwatch_log_group" "basic_api" {
  name = local.basic_api_log_group
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api"
    }
  )
}

resource "aws_cloudwatch_log_group" "s3_api" {
  name = local.s3_api_log_group
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api"
    }
  )
}

resource "aws_cloudwatch_log_group" "auth_api" {
  name = local.auth_api_log_group
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api"
    }
  )
}

resource "aws_cloudwatch_log_group" "crawler" {
  name = local.crawler_log_group
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-crawler"
    }
  )
}
