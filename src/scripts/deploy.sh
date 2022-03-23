#!/bin/bash

# Requirements:
#  - Localstack CLI (for local only)
#  - Terraform CLI
#  - Docker

set -e

aws_region=us-west-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=$aws_region

root=$(
  cd "$(dirname "$0")"/../..
  pwd
)

is_ci="false"

while getopts "c" options; do
  case "${options}" in
  c)
    is_ci="true"
    shift
    ;;
  *)
    exit 1
    ;;
  esac
done

# api key is required for both local and CI
if [[ -z "${LOCALSTACK_API_KEY}" ]]; then
  echo "\"LOCALSTACK_API_KEY\" environment variable is required. Please set this value using the key found here: https://app.localstack.cloud/account#apikeys"
  exit 1
fi

# create localstack and DB (if required)
cd "$root"
set +e

nc -z localhost 4566 >>/dev/null
if [ "$?" -gt 0 ]; then
  echo "Starting localstack docker container..."
  DEBUG=1 localstack start -d
  localstack status
fi

set -e

# create local infrastructure
cd terraform
terraform init -no-color
terraform plan -no-color -compact-warnings
terraform apply -no-color -compact-warnings -auto-approve
