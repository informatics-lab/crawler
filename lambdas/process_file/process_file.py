from __future__ import print_function

import os
import tempfile

import boto3
import iris


def main(event, context):
    process_object_from_s3(
        "s3://mogreps-g/201612/prods_op_mogreps-g_20161203_00_00_048.pp")


def parse_s3_uri(s3_uri):
    nasty_stuff = s3_uri.split("/")
    _, extension = os.path.splitext(s3_uri)
    bucket = nasty_stuff[2]
    key = "/".join(nasty_stuff[3:])

    return bucket, key, extension


def download_object(s3_uri):
    bucket, key, extension = parse_s3_uri(s3_uri)
    print(bucket, key, extension)
    data_file = tempfile.NamedTemporaryFile(mode='w+b', suffix=extension)
    s3 = boto3.resource('s3')
    s3.Object(bucket, key).download_file(data_file.name)

    return data_file


def process_object_from_s3(s3_uri):
    data_file = download_object(s3_uri)
    cubes = iris.load(data_file.name)
    for cube in cubes:    
        print(cube)
    print("Done")


if __name__ == "__main__":
    main(None, None)
