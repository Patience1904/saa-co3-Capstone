import boto3
import json

s3 = boto3.client('s3')
translate = boto3.client('translate')

def handler(event, context):
    # Get file from S3 event
    record = event['Records'][0]['s3']
    bucket = record['bucket']['name']
    key = record['object']['key']
    
    # Download JSON
    file = s3.get_object(Bucket=bucket, Key=key)
    data = json.loads(file['Body'].read())
    
    # Translate text
    result = translate.translate_text(
        Text=data['text'],
        SourceLanguageCode=data['source_lang'],
        TargetLanguageCode=data['target_lang']
    )
    
    # Upload result
    s3.put_object(
        Bucket='response-bucket-<UNIQUE_ID>',
        Key=f"translated_{key}",
        Body=json.dumps({
            "original_text": data['text'],
            "translated_text": result['TranslatedText']
        })
    )