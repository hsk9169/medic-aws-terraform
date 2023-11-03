resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-${var.service_name}-${var.env}-cluster"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-cluster"
    }
  )
}

resource "aws_service_discovery_service" "app_service" {
  name = "${var.service_name}-${var.env}"
  dns_config {
    namespace_id = local.service_namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
    dns_records {
      ttl  = 10
      type = "SRV"
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "basic_api" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api"
  cluster         = aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.basic_api.arn
  desired_count   = var.az_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.basicApi-fargate_task.id]
    subnets         = [for s in aws_subnet.private : s.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.basicApi-tg.id
    container_name   = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api"
    container_port   = var.service_port_main
  }

  depends_on = [
    aws_alb_listener.basic_api_target,
    aws_iam_role_policy_attachment.basicApi-fargate-execution,
    aws_ecs_task_definition.basic_api
  ]
}

resource "aws_ecs_service" "s3_api" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api"
  cluster         = aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.s3_api.arn
  desired_count   = var.az_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.s3Api-fargate_task.id]
    subnets         = [for s in aws_subnet.private : s.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.s3Api-tg.id
    container_name   = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api"
    container_port   = var.service_port_main
  }

  depends_on = [
    aws_alb_listener.s3_api_target,
    aws_iam_role_policy_attachment.s3Api-fargate-execution,
    aws_ecs_task_definition.s3_api
  ]
}

resource "aws_ecs_service" "auth_api" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api"
  cluster         = aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.auth_api.arn
  desired_count   = var.az_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.authApi-fargate_task.id]
    subnets         = [for s in aws_subnet.private : s.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.authApi-tg.id
    container_name   = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api"
    container_port   = var.service_port_main
  }

  depends_on = [
    aws_alb_listener.auth_api_target,
    aws_iam_role_policy_attachment.authApi-fargate-execution,
    aws_ecs_task_definition.auth_api
  ]
}
