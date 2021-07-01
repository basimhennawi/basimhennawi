#!/usr/bin/env bash

# exit on error even if parts of a pipe fail
set -e -o pipefail

###### Inputs ######
ACCOUNT_NAME="$1"

###### Input checks ######
if [[ -z "${ACCOUNT_NAME}" ]]; then
    echo "Please set ACCOUNT_NAME as first parameter (e.g. transit_gateway_nonprod, ..)"
    exit 1
fi

if [[ -z "${AWS_PROFILE}" ]]; then
    export AWS_PROFILE=$(jq -r .profiles.${ACCOUNT_NAME} ../common.tfvars.json)
    echo "Environment variable AWS_PROFILE not set. Using '${AWS_PROFILE}' as profile."
fi

if [[ -z "${AWS_REGION}" ]]; then
    export AWS_REGION=$(jq -r .region ../common.tfvars.json)
    echo "Environment variable AWS_REGION not set. Using '${AWS_REGION}' as default."
fi


###### Main ######

echo "Check if aws credentials are valid"
aws sts get-caller-identity

# select workspace or setup workspace, if it is unknown locally
terraform workspace select "${ACCOUNT_NAME}" || ./init.sh "${ACCOUNT_NAME}"

terraform destroy \
  -var-file=../common.tfvars.json
