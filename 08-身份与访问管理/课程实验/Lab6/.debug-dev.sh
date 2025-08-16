# set the subscription (replace with your subscription/tenant)
# export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
# export ARM_TENANT_ID="<your-tenant-id>"

# set the application / environment
export TF_VAR_application_name="linuxvm"
export TF_VAR_environment_name="dev"

# set the tags
export TF_VAR_lab_name="Lab6"

# set the backend (replace with your backend storage account/rg)
export BACKEND_RESOURCE_GROUP="<backend-resource-group>"
export BACKEND_STORAGE_ACCOUNT="<backend-storage-account>"
export BACKEND_CONTAINER_NAME="<backend-container-name>"
export BACKEND_KEY="${TF_VAR_application_name}-${TF_VAR_environment_name}"

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform