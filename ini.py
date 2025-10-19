import os
from flask import Flask, jsonify, request
import boto3
from aws_lambda_wsgi import response

# Initialize Flask app
app = Flask(__name__)

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')

# Use a default value if the environment variable is not set
TABLE_NAME = os.environ.get('TABLE_NAME', 'example_table')  # Use the correct table name

@app.route('/files', methods=['GET'])
def list_files():
    try:
        table = dynamodb.Table(TABLE_NAME)
        response = table.scan()
        files = response.get('Items', [])
        
        # Pagination for large datasets
        page_size = int(request.args.get('page_size', '10'))
        start_index = int(request.args.get('start_index', '0'))
        end_index = min(start_index + page_size, len(files))
        
        return jsonify(files[start_index:end_index])
    except Exception as e:
        import logging
        logging.error(str(e))
        return jsonify({"error": "Internal Server Error"}), 500

# Lambda handler function
def lambda_handler(event, context):
    from aws_lambda_wsgi import response
    # WSGI handler that integrates Flask with AWS Lambda
    return response(app, event, context)
