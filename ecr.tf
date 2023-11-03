resource "aws_ecr_repository" "basic-api" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-basic-api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "s3-api" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-s3-api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "auth-api" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-auth-api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "api-cralwer" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-crawler"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "hosp-info" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "authorizer" {
  name                 = "${var.name_prefix}-${var.service_name}-${var.env}-authorizer"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
