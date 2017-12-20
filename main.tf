provider "aws" {
  region  = "us-west-2"
}

resource "aws_iam_role" "lambda_geoip_role" {
  name = "lambda-geoip-role"
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

resource "aws_iam_role_policy" "lambda_geoip_policy" {
  name = "lambda-geoip-policy"
  role = "${aws_iam_role.lambda_geoip_role.id}"
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

resource "aws_lambda_function" "geoip" {
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda_zip.output_path}"))}"
  function_name    = "geoip"
  role             = "${aws_iam_role.lambda_geoip_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  timeout          = 30
  publish          = true
}
