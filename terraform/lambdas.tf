resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
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

resource "aws_lambda_function" "dd_on_ingest" {
    filename = "dd_on_ingest.zip"
    function_name = "dd_on_ingest"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "on_ingest.main"
    source_code_hash = "${base64sha256(file("dd_on_ingest.zip"))}"
    provisioner "local-exec" {
        command = "zip dd_on_ingest.zip lambdas/on_ingest"
    }
}

resource "aws_lambda_function" "dd_on_scan" {
    filename = "dd_on_scan.zip"
    function_name = "dd_on_scan"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "on_scan.main"
    source_code_hash = "${base64sha256(file("dd_on_scan.zip"))}"
    provisioner "local-exec" {
        command = "zip dd_on_scan.zip lambdas/on_scan"
    }
}

resource "aws_lambda_function" "dd_process_file" {
    filename = "dd_process_file.zip"
    function_name = "dd_process_file"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "process_file.main"
    source_code_hash = "${base64sha256(file("dd_process_file.zip"))}"
    provisioner "local-exec" {
        command = "zip dd_process_file.zip lambdas/process_file"
    }
}