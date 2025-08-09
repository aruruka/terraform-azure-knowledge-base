# set the subscription
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="11111111-1111-1111-1111-111111111111"

# set the application / environment
export TF_VAR_application_name="synthetic-app"
export TF_VAR_environment_name="synthetic-env"

# set the tags
export TF_VAR_lab_name="synthetic-lab"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-synthetic-state-dev"
export BACKEND_STORAGE_ACCOUNT="syntheticstorage"
export BACKEND_CONTAINER_NAME="syntheticcontainer"
export BACKEND_KEY="synthetic-key"

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform