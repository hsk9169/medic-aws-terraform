resource "aws_security_group" "vpc_endpoint" {
  name   = "${var.name_prefix}-${var.env}-vpc_endpoint-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpce-sg"
    }
  )
}

resource "aws_security_group" "alb" {
  name   = "${var.name_prefix}-${var.service_name}-${var.env}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 8080
    to_port          = 8080
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "basicApi-fargate_task" {
  name   = "${var.name_prefix}-${var.service_name}-basic-api-task-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.service_port_main
    to_port     = var.service_port_main
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api-task-sg"
    }
  )
}

resource "aws_security_group" "s3Api-fargate_task" {
  name   = "${var.name_prefix}-${var.service_name}-s3-api-task-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.service_port_main
    to_port     = var.service_port_main
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.service_port_sub
    to_port     = var.service_port_sub
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.secret_port
    to_port     = var.secret_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api-task-sg"
    }
  )
}

resource "aws_security_group" "authApi-fargate_task" {
  name   = "${var.name_prefix}-${var.service_name}-auth-api-task-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.service_port_main
    to_port     = var.service_port_main
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api-task-sg"
    }
  )
}

resource "aws_security_group" "crawler-fargate_task" {
  name   = "${var.name_prefix}-${var.service_name}-crawler-task-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.service_port_main
    to_port     = var.service_port_main
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.service_port_sub
    to_port     = var.service_port_sub
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.secret_port
    to_port     = var.secret_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-crawler-task-sg"
    }
  )
}

resource "aws_security_group" "hosp_info_rdb" {
  name   = "${var.name_prefix}-${var.service_name}-hosp-info-rdb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.service_port_main
    to_port     = var.service_port_main
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.service_port_sub
    to_port     = var.service_port_sub
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.secret_port
    to_port     = var.secret_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}- hosp-info-rdb-sg"
    }
  )
}
