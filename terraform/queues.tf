resource "aws_sns_topic" "dd_to_extract_metadata_topic" {
  name = "dd_to_extract_metadata"
}

resource "aws_sns_topic_policy" "dd_to_extract_metadata_topic_policy" {
  arn = "${aws_sns_topic.dd_to_extract_metadata_topic.arn}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid": "allow_publish",
    "Effect": "Allow",
    "Principal": "*",
    "Action": [
      "SNS:Publish"
    ],
    "Resource": "${aws_sns_topic.dd_to_extract_metadata_topic.arn}"
  }]
}
POLICY
}

resource "aws_sqs_queue" "dd_to_extract_metadata_queue" {
    name = "dd_to_extract_metadata"
}

resource "aws_sqs_queue_policy" "dd_to_extract_metadata_queue_policy" {
  queue_url = "${aws_sqs_queue.dd_to_extract_metadata_queue.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid":"allow_push_to_queue",
    "Effect":"Allow",
    "Principal":"*",
    "Action": [
      "SQS:*"
    ],
    "Resource":"${aws_sqs_queue.dd_to_extract_metadata_queue.arn}",
    "Condition":{
      "ArnEquals":{
        "aws:SourceArn":"${aws_sns_topic.dd_to_extract_metadata_topic.arn}"
      }
    }
  }]
}
POLICY
}

resource "aws_sns_topic_subscription" "dd_to_extract_metadata_target" {
    topic_arn = "${aws_sns_topic.dd_to_extract_metadata_topic.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.dd_to_extract_metadata_queue.arn}"
}
