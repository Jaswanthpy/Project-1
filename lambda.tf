resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = file("IAM/role")
}


resource "aws_iam_role_policy" "sqs_lambda" {
  name = "sqs_lambda_policy"
  role = aws_iam_role.iam_for_lambda.id
  policy = file("IAM/sqs_lambda_policy")
}


resource "aws_iam_role_policy" "s3_lambda" {
  name = "s3_lambda_policy"
  role = aws_iam_role.iam_for_lambda.id
  policy = file("IAM/s3_lambda_policy")
}


variable "lambda_function_name" {
  default = "test_lambda"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}


resource "aws_iam_role_policy" "cloudwatch_lambda" {
  name = "cloudwatch_lambda_policy"
  role = aws_iam_role.iam_for_lambda.id
  policy = file("IAM/cloudwatch-lambda-policy")
}


data "archive_file" "init" {
  type = "zip"
  source_file = "hello.py"
  output_path = "init.zip"
}


resource "aws_lambda_function" "test_lambda" {
  filename = "init.zip"
  function_name = "test_lambda"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "hello.hello"
  source_code_hash = filebase64sha256("init.zip")
  runtime = "python3.8"
  depends_on = [
  aws_iam_role_policy.cloudwatch_lambda,
  aws_cloudwatch_log_group.lambda_logs,
  aws_iam_role_policy.s3_lambda,
  aws_iam_role_policy.sqs_lambda,
  aws_iam_role.iam_for_lambda
  ]
}