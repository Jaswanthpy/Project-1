resource "aws_s3_bucket" "lambda_s3" {
  bucket = "tf-lambda-s3-pload"
  force_destroy = "true"
}