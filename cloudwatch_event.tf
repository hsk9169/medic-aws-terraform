resource "aws_cloudwatch_event_rule" "crawler" {
  name                = "${var.name_prefix}-${var.service_name}-${var.env}-crawler-event-rule"
  description         = "심평원 전국 병의원 API 주기적으로 조회하는 태스크"
  is_enabled          = true
  schedule_expression = "rate(7 days)"
}

resource "aws_cloudwatch_event_target" "crawler" {
  count     = 1
  target_id = "${var.name_prefix}-${var.service_name}-${var.env}-crawler"
  arn       = aws_ecs_cluster.main.arn
  rule      = aws_cloudwatch_event_rule.crawler.name
  role_arn  = aws_iam_role.crawler-fargate_task.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.crawler.arn
    platform_version    = "LATEST"
    network_configuration {
      assign_public_ip = true
      security_groups  = [aws_security_group.crawler-fargate_task.id]
      subnets          = [for s in aws_subnet.private : s.id]
    }
  }
}
