# File Storage and Metadata Management System

This project is a cloud-based solution for uploading files to Amazon S3 and storing metadata in a DynamoDB table. It also provides an API for listing stored files.

## Features
- **File Upload**: Upload files to S3 via an AWS Lambda function.
- **Metadata Storage**: Store file metadata in DynamoDB.
- **File Listing**: Use a Flask-based application to retrieve a list of uploaded files.
- **Secure APIs**: Authentication and validation mechanisms implemented.

---

## Prerequisites
1. **AWS Account**: Ensure you have an active AWS account.
2. **Tools Installed**:
   - AWS CLI
   - Python (3.x)
   - Terraform
   - pip (Python package manager)
3. **Environment Variables**:
   - `BUCKET_NAME`: Name of the S3 bucket.
   - `TABLE_NAME`: Name of the DynamoDB table.

---


1. **File Upload API**:
   - **Lambda Function**: Handles file uploads to S3 and metadata storage in DynamoDB.
2. **File Listing API**:
   - **Flask Application**: Lists files stored in DynamoDB, with basic pagination and authentication.
3. **Infrastructure as Code**:
   - **Terraform**: Automates the creation of S3 bucket, DynamoDB table, and API Gateway.

---

## Setup Instructions

### 1. Deploy Infrastructure

1. **Navigate to Terraform Directory**:
   ```bash
   cd terraform
   ```
2. **Initialize Terraform**:
   ```bash
   terraform init
   ```
3. **Deploy Resources**:
   ```bash
   terraform apply
   ```
4. **Note Outputs**:
   Copy the `api_endpoint`, `dynamodb_table_name`, and `s3_bucket_name` from the Terraform output.

---

### 2. Set Up Environment Variables

Export the required environment variables:

```bash
export BUCKET_NAME=<your-bucket-name>
export TABLE_NAME=<your-table-name>
```

---

### 3. Deploy Lambda Function

1. **Navigate to Lambda Directory**:
   ```bash
   cd lambda_function
   ```
2. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt -t .
   ```
3. **Zip and Deploy**:
   ```bash
   zip -r function.zip .
   aws lambda app.py --function-name --zip-file fileb://function.zip
   ```

