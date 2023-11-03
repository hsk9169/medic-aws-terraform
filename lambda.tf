data "aws_ecr_repository" "hosp_info" {
  name = aws_ecr_repository.hosp-info.name
}

data "aws_ecr_repository" "apigw_authorizer" {
  name = aws_ecr_repository.authorizer.name
}

resource "aws_lambda_function" "hosp_info" {
  function_name = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info"
  timeout       = 30 # seconds
  image_uri     = "${data.aws_ecr_repository.hosp_info.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda-function.arn
  vpc_config {
    subnet_ids         = concat(aws_subnet.private.*.id, aws_subnet.public.*.id)
    security_group_ids = [aws_security_group.hosp_info_rdb.id]
  }
  depends_on = [
    aws_cloudwatch_log_group.hosp_info,
    aws_iam_role.lambda-function,
  ]
}

resource "aws_lambda_function" "apigw_authorizer" {
  function_name = "${var.name_prefix}-${var.service_name}-${var.env}-authorizer"
  timeout       = 30 # seconds
  image_uri     = "${data.aws_ecr_repository.apigw_authorizer.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda-function.arn

  depends_on = [
    aws_cloudwatch_log_group.apigw_authorizer,
    aws_iam_role.lambda-function,
  ]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hosp_info.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "hosp_info" {
  name = "/${var.name_prefix}-${var.service_name}-${var.env}-hosp-info-lambda/log"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info-lambda"
    }
  )
}

resource "aws_cloudwatch_log_group" "apigw_authorizer" {
  name = "/${var.name_prefix}-${var.service_name}-${var.env}-authorizer-lambda/log"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-authorizer-lambda"
    }
  )
}

#provider "docker" {
#  registry_auth {
#    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
#    username = data.aws_ecr_authorization_token.token.user_name
#    password = data.aws_ecr_authorization_token.token.password
#  }
#}
#
#module "lambda_function_from_container_image" {
#  source        = "terraform-aws-modules/lambda/aws//"
#  function_name = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info"
#  description   = "심평원 병원 리스트 검색 함수"
#  timeout       = 30
#  memory_size   = 256
#
#  create_package             = false
#  create_lambda_function_url = true
#
#  ##################
#  # Container Image
#  ##################
#  image_uri     = module.docker_image.image_uri
#  package_type  = "Image"
#  architectures = ["x86_64"]
#
#  vpc_config {
#    subnet_ids         = aws_subnet.private.*.id
#    security_group_ids = [aws_security_group.hosp_info_rdb.id]
#  }
#
#  #depends_on = [
#  #  aws_iam_role.lambda-function,
#  #]
#}
#
#module "docker_image" {
#  source = "terraform-aws-modules/lambda/aws//modules/docker-build"
#
#  create_ecr_repo = true
#  ecr_repo        = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info"
#  ecr_repo_lifecycle_policy = jsonencode({
#    "rules" : [
#      {
#        "rulePriority" : 1,
#        "description" : "Keep only the last 2 images",
#        "selection" : {
#          "tagStatus" : "any",
#          "countType" : "imageCountMoreThan",
#          "countNumber" : 2
#        },
#        "action" : {
#          "type" : "expire"
#        }
#      }
#    ]
#  })
#
#  image_tag   = "latest"
#  source_path = "./hosp_info"
#  platform    = "x86_64"
#}
