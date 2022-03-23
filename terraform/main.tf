terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.1.0"
}

locals {
  aws_region     = "us-west-1"
  local_endpoint = "http://localhost:4566"
}

provider "aws" {
  region     = local.aws_region
  access_key = "test"
  secret_key = "test"

  s3_use_path_style          = true
  skip_metadata_api_check    = true
  skip_requesting_account_id = true

  endpoints {
    apigateway       = local.local_endpoint
    apigatewayv2     = local.local_endpoint
    cloudformation   = local.local_endpoint
    cloudwatch       = local.local_endpoint
    cloudwatchlogs   = local.local_endpoint
    cloudwatchevents = local.local_endpoint
    dynamodb         = local.local_endpoint
    ec2              = local.local_endpoint
    es               = local.local_endpoint
    elasticache      = local.local_endpoint
    firehose         = local.local_endpoint
    iam              = local.local_endpoint
    kinesis          = local.local_endpoint
    lambda           = local.local_endpoint
    rds              = local.local_endpoint
    redshift         = local.local_endpoint
    route53          = local.local_endpoint
    s3               = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager   = local.local_endpoint
    ses              = local.local_endpoint
    sns              = local.local_endpoint
    sqs              = local.local_endpoint
    ssm              = local.local_endpoint
    stepfunctions    = local.local_endpoint
    sts              = local.local_endpoint
    transfer         = local.local_endpoint
  }
}

resource "aws_lambda_function" "hello" {
  function_name    = "test"
  filename         = "../dist/lambda.zip"
  handler          = "handlers.test"
  source_code_hash = filebase64sha256("../dist/lambda.zip")
  role             = aws_iam_role.hello.arn
  runtime     = "nodejs14.x"
  memory_size      = 128
  timeout          = 1
}

resource "aws_iam_role" "hello" {
  name               = "hello"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow"
  }
}
POLICY
}


# # the trust policy for the role
# data "aws_iam_policy_document" "trust" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# # the iam execution role for lambda function
# resource "aws_iam_role" "this" {
#   name               = "${local.name}-exec"
#   assume_role_policy = data.aws_iam_policy_document.trust.json
#   tags               = var.tags
# }

# # adding aws managed lambda policy to the role
# resource "aws_iam_role_policy_attachment" "lambda" {
#   role       = aws_iam_role.this.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
# }

# # adding external policy to the execution role
# resource "aws_iam_role_policy" "external" {
#   count = var.enable_external_policy ? 1 : 0

#   name   = "${local.name}-policy"
#   role   = aws_iam_role.this.id
#   policy = var.external_policy
# }


# data "aws_region" "current" {}

# locals {
#   name = "test-function"
# }

# resource "aws_lambda_function" "this" {
#   function_name = local.name
#   role          = aws_iam_role.this.arn

#   filename         = var.source_code
#   source_code_hash = filebase64sha256("../../dist/lambda.zip")
#   handler          = "handlers.test"

#   runtime     = "nodejs14.x"
#   memory  = 512
#   timeout = 300 # 5 minutes

#   vpc_config {
#     subnet_ids         = var.subnet_ids
#     security_group_ids = var.security_group_ids
#     subnet_ids         = ["subnet-12345678"]
#     security_group_ids = ["sg-12345678"]
#   }

#   environment {
#     variables = var.env_vars
#   }

#   tags = var.tags
# }

# resource "aws_cloudwatch_log_group" "this" {
#   depends_on = [aws_lambda_function.this]

#   name              = "/aws/lambda/${local.name}"
#   retention_in_days = 90
# }

# module "billing_connect" {
#   source     = "../modules/billing-connect"
#   depends_on = [aws_secretsmanager_secret_version.local]

#   aws_region = local.aws_region
#   env        = "local"

#   subnet_ids         = ["subnet-12345678"]
#   security_group_ids = ["sg-12345678"]
#   nat_ips            = ["natips-12345678"]
#   mongodb_uri        = local.mongodb_uri

#   lambda_dist_package         = "../../dist/lambda.zip"
#   export_schedule_expression  = "rate(1 minute)"
#   export_artifact_ttl_seconds = 60 # 1 minute

#   customer_names = []
# }
