resource "aws_sns_topic" "dd_to_extract_metadata_topic" {
  name = "dd_to_extract_metadata"
}

resource "aws_sqs_queue" "dd_to_extract_metadata_queue" {
    name = "dd_to_extract_metadata"
}

resource "aws_sns_topic_subscription" "dd_to_extract_metadata_target" {
    topic_arn = "${aws_sns_topic.dd_to_extract_metadata_topic.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.dd_to_extract_metadata_queue.arn}"
}
