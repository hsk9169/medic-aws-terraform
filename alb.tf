######## basic api ######## 
resource "aws_alb" "basicApi" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
  idle_timeout    = 90
}

resource "aws_alb_target_group" "basicApi-tg" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api-tg"
  port                 = var.service_port_main
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = 60
  stickiness {
    enabled = true
    type    = "lb_cookie"

  }

  health_check {
    healthy_threshold   = "2"
    interval            = "180"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "basic_api_target" {
  load_balancer_arn = aws_alb.basicApi.arn
  port              = var.service_port_main
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.basicApi-tg.arn
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.basicApi-tg]
}


######## s3 api ######## 
resource "aws_alb" "s3Api" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
  idle_timeout    = 90
}

resource "aws_alb_target_group" "s3Api-tg" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api-tg"
  port                 = var.service_port_main
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = 60
  stickiness {
    enabled = true
    type    = "lb_cookie"

  }

  health_check {
    healthy_threshold   = "2"
    interval            = "180"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "s3_api_target" {
  load_balancer_arn = aws_alb.s3Api.arn
  port              = var.service_port_main
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.s3Api-tg.arn
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.s3Api-tg]
}


######## auth api ######## 
resource "aws_alb" "authApi" {
  name            = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
  idle_timeout    = 90
}

resource "aws_alb_target_group" "authApi-tg" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api-tg"
  port                 = var.service_port_main
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = 60
  stickiness {
    enabled = true
    type    = "lb_cookie"

  }

  health_check {
    healthy_threshold   = "2"
    interval            = "180"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "auth_api_target" {
  load_balancer_arn = aws_alb.authApi.arn
  port              = var.service_port_main
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.authApi-tg.arn
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.authApi-tg]
}
