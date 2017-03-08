import boto3 as boto
from botocore.exceptions import ClientError


def fix_awful_boto_dict(dictionary):
    tags = {}
    for tag in dictionary:
        tags[tag["Key"]] = tag["Value"]
    return tags


def post_file(filename):
    sqs = boto.client('sns')
    response = sqs.publish(
        TopicArn='arn:aws:sns:eu-west-2:536099501702:dd_to_extract_metadata',
        Message=filename
    )
    return response


def add_objects_to_queue(bucket):
    for page in bucket.objects.pages():
        for obj in page:
            filename = "s3://{}/{}".format(bucket.name, obj.key)
            post_file(filename)


def main(event, context):
    s3 = boto.resource('s3')
    for bucket in s3.buckets.all():
        try:
            tags = fix_awful_boto_dict(bucket.Tagging().tag_set)
            if "modata" == tags["collection"]:
                add_objects_to_queue(bucket)
        except (ClientError, KeyError):
            pass
