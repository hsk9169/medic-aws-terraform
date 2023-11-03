resource "aws_api_gateway_authorizer" "main" {
  name                             = "${var.name_prefix}-${var.service_name}-${var.env}-apigw-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.main.id
  authorizer_uri                   = aws_lambda_function.apigw_authorizer.invoke_arn
  authorizer_credentials           = aws_iam_role.apigw_invocation_role.arn
  identity_source                  = "method.request.header.Authorization"
  type                             = "REQUEST"
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_api_gateway_rest_api" "main" {
  name = "${var.name_prefix}-${var.service_name}-${var.env}-apigw-rest"
  #count = 1
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-apigw-rest"
    }
  )
}


######## auth api path
data "aws_alb" "auth-api" {
  name = aws_alb.authApi.name
}

resource "aws_api_gateway_resource" "auth_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "auth"
}

resource "aws_api_gateway_resource" "auth_proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.auth_root.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "auth_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.auth_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.main.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "auth_alb" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.auth_proxy.id
  http_method = aws_api_gateway_method.auth_proxy.http_method

  request_parameters      = { "integration.request.path.proxy" = "method.request.path.proxy" }
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.auth-api.dns_name}:8080/{proxy}"
}

resource "aws_api_gateway_resource" "auth_signin" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.auth_root.id
  path_part   = "signin"
}

resource "aws_api_gateway_method" "auth_signin" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.auth_signin.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "auth_signin" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.auth_signin.id
  http_method = aws_api_gateway_method.auth_signin.http_method

  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.auth-api.dns_name}:8080/signin"
}


######## basic api path
data "aws_alb" "basic-api" {
  name = aws_alb.basicApi.name
}

## /basic-api
resource "aws_api_gateway_resource" "basic_api_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "basic-api"
}

#### /{proxy+}
resource "aws_api_gateway_resource" "basic_proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.basic_api_root.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "basic_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.basic_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.main.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "basic_alb" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.basic_proxy.id
  http_method = aws_api_gateway_method.basic_proxy.http_method

  request_parameters      = { "integration.request.path.proxy" = "method.request.path.proxy" }
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.basic-api.dns_name}:8080/{proxy}"
}

#### /medic/create
resource "aws_api_gateway_resource" "basic_medic" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.basic_api_root.id
  path_part   = "medic"
}

resource "aws_api_gateway_resource" "basic_medic_create" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.basic_medic.id
  path_part   = "create"
}

resource "aws_api_gateway_method" "basic_medic_create" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.basic_medic_create.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "basic_medic_create" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.basic_medic_create.id
  http_method = aws_api_gateway_method.basic_medic_create.http_method

  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.basic-api.dns_name}:8080/medic/create"
}


######## s3 api path
data "aws_alb" "s3-api" {
  name = aws_alb.s3Api.name
}

resource "aws_api_gateway_resource" "s3_api_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "s3-api"
}

resource "aws_api_gateway_resource" "s3_proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.s3_api_root.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "s3_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.s3_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.main.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "s3_alb" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.s3_proxy.id
  http_method = aws_api_gateway_method.s3_proxy.http_method

  request_parameters      = { "integration.request.path.proxy" = "method.request.path.proxy" }
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.s3-api.dns_name}:8080/{proxy}"
}

resource "aws_api_gateway_resource" "s3_auth" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.s3_api_root.id
  path_part   = "auth"
}

resource "aws_api_gateway_method" "s3_auth_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.s3_auth.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "s3_auth_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.s3_auth.id
  http_method = aws_api_gateway_method.s3_auth_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.s3-api.dns_name}:8080/auth"
}

resource "aws_api_gateway_method" "s3_auth_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.s3_auth.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "s3_auth_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.s3_auth.id
  http_method = aws_api_gateway_method.s3_auth_post.http_method

  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_alb.s3-api.dns_name}:8080/auth"
}


######## hosp info path
resource "aws_api_gateway_resource" "hosp_info_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "hosp-info"
}

resource "aws_api_gateway_method" "hosp_info_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.hosp_info_root.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hosp_info_lambda" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.hosp_info_root.id
  http_method = aws_api_gateway_method.hosp_info_get.http_method

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hosp_info.invoke_arn
}


resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.hosp_info_lambda,
    aws_api_gateway_integration.auth_alb,
    aws_api_gateway_integration.auth_signin,
    aws_api_gateway_integration.basic_alb,
    aws_api_gateway_integration.basic_medic_create,
    aws_api_gateway_integration.s3_alb,
    aws_api_gateway_integration.s3_auth_get,
    aws_api_gateway_integration.s3_auth_post,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = var.env
}

resource "aws_api_gateway_stage" "main" {
  deployment_id        = aws_api_gateway_deployment.main.id
  rest_api_id          = aws_api_gateway_rest_api.main.id
  stage_name           = var.env
  xray_tracing_enabled = true
  depends_on           = [aws_cloudwatch_log_group.api_gateway]
}

resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  name = "${var.name_prefix}-${var.service_name}-${var.env}-apigw/log"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-apigw"
    }
  )
}
