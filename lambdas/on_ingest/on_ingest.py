import boto3 as boto


def post_file(filename, queue_name="new_files"):
    sqs = boto.client('sns')
    response = sqs.publish(
        TopicArn='arn:aws:sns:eu-west-2:536099501702:dd_to_extract_metadata',
        Message=filename
    )
    return response

def main(event, context):
    filename = "s3://{}/{}".format(
        event["Records"][0]["s3"]["bucket"]["name"],
        event["Records"][0]["s3"]["object"]["key"])
    print post_file(filename)
