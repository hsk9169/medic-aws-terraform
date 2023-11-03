######## role defs ######## 
resource "aws_iam_role" "basicApi-fargate_execution" {
  name               = "${var.name_prefix}-${var.service_name}-basic-api-${var.env}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "basicApi-fargate_task" {
  name               = "${var.name_prefix}-${var.service_name}-basic-api-${var.env}-fargate-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "s3Api-fargate_execution" {
  name               = "${var.name_prefix}-${var.service_name}-s3-api-${var.env}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "s3Api-fargate_task" {
  name               = "${var.name_prefix}-${var.service_name}-s3-api-${var.env}-fargate-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "authApi-fargate_execution" {
  name               = "${var.name_prefix}-${var.service_name}-auth-api-${var.env}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "authApi-fargate_task" {
  name               = "${var.name_prefix}-${var.service_name}-auth-api-${var.env}-fargate-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "crawler-fargate_execution" {
  name               = "${var.name_prefix}-${var.service_name}-crawler-${var.env}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "crawler-fargate_task" {
  name               = "${var.name_prefix}-${var.service_name}-crawler-${var.env}-fargate-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "lambda-function" {
  name               = "${var.name_prefix}-${var.service_name}-${var.env}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_task_role.json
}

resource "aws_iam_role" "apigw_invocation_role" {
  name               = "api_gateway_auth_invocation"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apigw_invocation_assume_role.json
}


######## attach policies to role ########
#### basic api
resource "aws_iam_role_policy_attachment" "basicApi-fargate-execution" {
  role       = aws_iam_role.basicApi-fargate_execution.name
  policy_arn = aws_iam_policy.fargate_execution.arn
}

resource "aws_iam_role_policy_attachment" "basicApi-fargate-task-attach" {
  role       = aws_iam_role.basicApi-fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb-read-attach" {
  role       = aws_iam_role.basicApi-fargate_task.name
  policy_arn = aws_iam_policy.dynamodb-readpolicy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb-write-attach" {
  role       = aws_iam_role.basicApi-fargate_task.name
  policy_arn = aws_iam_policy.dynamodb-writepolicy.arn
}

#### s3 api
resource "aws_iam_role_policy_attachment" "s3Api-fargate-execution" {
  role       = aws_iam_role.s3Api-fargate_execution.name
  policy_arn = aws_iam_policy.fargate_execution.arn
}

resource "aws_iam_role_policy_attachment" "s3Api-fargate-task-attach" {
  role       = aws_iam_role.s3Api-fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}

resource "aws_iam_role_policy_attachment" "s3-policy-attach" {
  role       = aws_iam_role.s3Api-fargate_task.name
  policy_arn = aws_iam_policy.s3-policy.arn
}

#### auth api
resource "aws_iam_role_policy_attachment" "authApi-fargate-execution" {
  role       = aws_iam_role.authApi-fargate_execution.name
  policy_arn = aws_iam_policy.fargate_execution.arn
}

resource "aws_iam_role_policy_attachment" "authApi-fargate-task-attach" {
  role       = aws_iam_role.authApi-fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}

#### crawler
resource "aws_iam_role_policy_attachment" "crawler-fargate-execution" {
  role       = aws_iam_role.crawler-fargate_execution.name
  policy_arn = aws_iam_policy.fargate_execution.arn
}

resource "aws_iam_role_policy_attachment" "crawler-fargate-task-attach" {
  role       = aws_iam_role.crawler-fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}

resource "aws_iam_role_policy_attachment" "crawler-rds-policy-attach" {
  role       = aws_iam_role.crawler-fargate_task.name
  policy_arn = aws_iam_policy.rds_access.arn
}

#### lambda function
resource "aws_iam_role_policy_attachment" "ecs-access-policy-attach" {
  role       = aws_iam_role.lambda-function.name
  policy_arn = aws_iam_policy.ecs_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda-rds-policy-attach" {
  role       = aws_iam_role.lambda-function.name
  policy_arn = aws_iam_policy.rds_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch-access-policy-attach" {
  role       = aws_iam_role.lambda-function.name
  policy_arn = aws_iam_policy.cloudwatch_access.arn
}
