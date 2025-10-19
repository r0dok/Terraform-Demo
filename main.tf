
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "file_storage" {
  bucket = "file-storage-example-bucket"
  acl    = "private"
}

resource "aws_dynamodb_table" "file_metadata" {
  name           = "file_metadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "filename"

  attribute {
    name = "filename"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
}

resource "aws_lambda_function" "file_upload_api" {
  function_name = "file_upload_api"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.file_storage.id
      TABLE_NAME  = aws_dynamodb_table.file_metadata.name
    }
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "FileUploadAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "api_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.file_upload_api.invoke_arn
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /upload"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "prod"
  auto_deploy = true
}
