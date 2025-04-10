#!/bin/bash

# Define the AWS credentials file path
AWS_CREDENTIALS_FILE="$HOME/.aws/credentials"

PROFILE="default"

if [ ! -f "$AWS_CREDENTIALS_FILE" ]; then
    echo "AWS credentials file not found: $AWS_CREDENTIALS_FILE"
    exit 1
fi

TF_VAR_aws_access_key_id=$(grep -A3 "^\[$PROFILE\]" "$AWS_CREDENTIALS_FILE" | grep "aws_access_key_id" | sed 's/aws_access_key_id *= *//')
TF_VAR_aws_secret_access_key=$(grep -A3 "^\[$PROFILE\]" "$AWS_CREDENTIALS_FILE" | grep "aws_secret_access_key" | sed 's/aws_secret_access_key *= *//')
TF_VAR_aws_session_token=$(grep -A3 "^\[$PROFILE\]" "$AWS_CREDENTIALS_FILE" | grep "aws_session_token" | sed 's/aws_session_token *= *//')

if [[ -n "$TF_VAR_aws_access_key_id" && -n "$TF_VAR_aws_secret_access_key" && -n "$TF_VAR_aws_session_token" ]]; then
    export TF_VAR_aws_access_key_id TF_VAR_aws_secret_access_key TF_VAR_aws_session_token
    echo "AWS credentials exported for profile '$PROFILE'."
else
    echo "Failed to extract AWS credentials for profile '$PROFILE'."
    exit 1
fi

TF_VAR_sonarqube_db_name="sonarqube"
TF_VAR_sonarqube_db_username="postgres"
TF_VAR_sonarqube_db_password="postgres"
TF_VAR_mail_username="soatfiap@gmail.com"
TF_VAR_mail_password="plya bnjt dwzm rvel"

export TF_VAR_sonarqube_db_name TF_VAR_sonarqube_db_username TF_VAR_sonarqube_db_password TF_VAR_mail_username TF_VAR_mail_password

echo "Sonarqube postgres DB credentials exported."