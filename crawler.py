import iris
import boto3 as boto


def pickup_job(queue_name="new_files"):
    sqs = boto.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName=queue_name)




if __name__ == "__main__":
    job = pickup_job()
    if job:
        ingest_job(job)