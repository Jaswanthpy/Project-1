import boto3
import json

client_s3 = boto3.client('s3')

def hello(event, context):
    msg  = event["Records"][0]["body"]
    msgDict = json.loads(msg)
    with open("/tmp/hello.json", "w") as f:
        json.dump(msgDict, f, indent=4)
    client_s3.upload_file("/tmp/hello.json", "tf-lambda-s3-pload", "hello.json")
    return 0