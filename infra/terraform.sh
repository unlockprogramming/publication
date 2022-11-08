#!/bin/bash

set -e

assert_value() {

  if [ -z "$1" ]; then
    echo "No args: $2"
    exit 1
  fi

}

FILE="$PWD/.aws_env"
if test -f "$FILE"; then
    echo "$FILE exists."
    source "$FILE"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_S3_BUCKET=${TERRAFORM_S3_BUCKET:-terraform-unlockprogramming-com}
TERRAFORM_S3_BUCKET_REGION=${AWS_REGION:-us-east-1}

echo "--------------------------------------------------------"
echo "TERRAFORM_S3_BUCKET: $TERRAFORM_S3_BUCKET"
echo "TERRAFORM_S3_BUCKET_REGION: $TERRAFORM_S3_BUCKET_REGION"
echo "--------------------------------------------------------"

assert_value "$TERRAFORM_S3_BUCKET" "TERRAFORM_S3_BUCKET"
assert_value "$TERRAFORM_S3_BUCKET_REGION" "TERRAFORM_S3_BUCKET_REGION"

option="${1}"
assert_value "$option" "option"

if [ -z "$TF_VAR_release_name" ]; then
  read -r -p "Enter release name: " ARGS
  name=$ARGS
  export TF_VAR_release_name=$name
fi
export TF_VAR_aws_region=$AWS_REGION
export TF_DIR=$SCRIPT_DIR
assert_value "$TF_VAR_release_name" "TF_VAR_release_name"
assert_value "$TF_DIR" "TF_DIR"

export TF_LOG="INFO"
export TF_LOG_PATH="terraform.log"

select_workspace() {
  terraform workspace new "$TF_VAR_release_name" || true
  export TF_WORKSPACE=$TF_VAR_release_name
}

init_terraform() {
  cd "$TF_DIR" &&
    terraform init \
      -backend-config="key=terraform.tfstate" \
      -backend-config="encrypt=true" \
      -backend-config="region=$TERRAFORM_S3_BUCKET_REGION" \
      -backend-config="bucket=$TERRAFORM_S3_BUCKET" \
      -backend-config="workspace_key_prefix=$TF_VAR_release_name" && \
    select_workspace
}

case ${option} in
--deploy)
  init_terraform
  cd "$TF_DIR" && terraform apply -auto-approve
  ;;
--force-deploy)
  init_terraform
  cd "$TF_DIR" && terraform apply -auto-approve -refresh=false
  ;;
--destroy)
  init_terraform
  cd "$TF_DIR" && terraform destroy -auto-approve
  ;;
--force-destroy)
  init_terraform
  cd "$TF_DIR" && terraform destroy -auto-approve -refresh=false
  ;;
--sync-s3)
  aws s3 sync ./public/ s3://www.unlockprogramming.com
  ;;
--sync-cloudfront)
  aws cloudfront create-invalidation --distribution-id "$CLOUD_FRONT_ID1" --paths "/*" | jq '.'
  aws cloudfront create-invalidation --distribution-id "$CLOUD_FRONT_ID2" --paths "/*" | jq '.'
  ;;
*)
  echo "$(basename "${0}"):usage: [ run <make> to see more details]"
  exit 1 # Command to come out of the program with status 1
  ;;
esac
