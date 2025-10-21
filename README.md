```markdown
# S3 File Storage + DynamoDB Metadata

Flask API for uploading files to S3 and storing metadata in DynamoDB. Deployed via Terraform.

---

## Structure

```
terraform-demo/
├── app.py              → Flask API for listing files
├── ini.py              → Lambda handler wrapper
├── main.tf             → S3, DynamoDB, Lambda, API Gateway
├── outputs.tf          → API endpoint and resource names
└── variables.tf        → Region and bucket config
```

---

## What It Does

- **Upload**: Lambda function handles S3 uploads + metadata writes to DynamoDB
- **List**: Flask app queries DynamoDB with pagination
- **Deploy**: Terraform creates everything (S3, DynamoDB, Lambda, API Gateway)

---

## Setup

### Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

Note the outputs: `api_endpoint`, `s3_bucket_name`, `dynamodb_table_name`

### Configure Environment

```bash
export BUCKET_NAME=<your-bucket>
export TABLE_NAME=<your-table>
```

### Deploy Lambda

```bash
cd lambda_function
pip install -r requirements.txt -t .
zip -r function.zip .
aws lambda update-function-code \
  --function-name file_upload_api \
  --zip-file fileb://function.zip
```

---

## API

**List Files**: `GET /files`
- `page_size`: Items per page (default: 10)
- `start_index`: Pagination offset (default: 0)

```bash
curl https://your-api.execute-api.us-east-1.amazonaws.com/prod/files?page_size=20
```

---

## Notes

- S3 bucket is private by default
- DynamoDB uses PAY_PER_REQUEST billing
- Lambda has full S3 and DynamoDB access (lock this down for production)
```
