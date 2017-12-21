# terraform {
#   backend "s3" {
#     region         = "us-west-2"
#     # bucket, key, and dynamodb_table are provided via ./init.sh
#     bucket = "stevekehlet-terraform-state-us-west-2"
#     key = "lambda-invoke"
#     dynamodb_table = "terraform-state"
#   }
# }

provider "aws" {
  region  = "us-west-2"
}

resource "aws_iam_role" "lambda_weather_role" {
  name = "lambda-weather-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_weather_policy" {
  name = "lambda-weather-policy"
  role = "${aws_iam_role.lambda_weather_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "lambda"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "weather" {
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda_zip.output_path}"))}"
  function_name    = "weather"
  role             = "${aws_iam_role.lambda_weather_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  timeout          = 30
  publish          = true
}
