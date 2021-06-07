resource "aws_sqs_queue" "lambda_queue" {
  name = "lambda-terraform-queue"
}


resource "aws_lambda_event_source_mapping" "sqs_lambda_map" {
  event_source_arn = aws_sqs_queue.lambda_queue.arn
  function_name = aws_lambda_function.test_lambda.arn
}
