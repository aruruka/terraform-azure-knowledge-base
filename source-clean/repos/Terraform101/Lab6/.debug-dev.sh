# set the subscription
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="11111111-1111-1111-1111-111111111111"

# set the application / environment
export TF_VAR_application_name="linuxvm"
export TF_VAR_environment_name="dev"

# set the tags
export TF_VAR_lab_name="Lab6"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-tfstate-synth"
export BACKEND_STORAGE_ACCOUNT="synthstorageacct"
export BACKEND_CONTAINER_NAME="tfstate-synth"
export BACKEND_KEY="${TF_VAR_application_name}-${TF_VAR_environment_name}"

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform