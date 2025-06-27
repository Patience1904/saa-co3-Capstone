provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "request_bucket" {
  bucket = "request-bucket1-${var.unique_id}"
  lifecycle_rule { expiration_days = 30 }  # Free Tier cost control
}

resource "aws_s3_bucket" "response_bucket" {
  bucket = "response-bucket1-${var.unique_id}"
  lifecycle_rule { expiration_days = 30 }
}

resource "aws_iam_role" "translate_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "translate_s3_access" {
  role       = aws_iam_role.translate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranslateFullAccess"
}