output "api_endpoint" {
  value = aws_apigatewayv2_stage.api_stage.invoke_url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.file_storage.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.file_metadata.name
}
