# set the subscription
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000" # synthetic placeholder
export ARM_TENANT_ID="11111111-1111-1111-1111-111111111111"       # synthetic placeholder

# set the application / environment
export TF_VAR_application_name="azapivm"
export TF_VAR_environment_name="dev"

# set the tags
export TF_VAR_lab_name="Lab7"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-dev-synth"
export BACKEND_STORAGE_ACCOUNT="syntheticstorageacct123"
export BACKEND_CONTAINER_NAME="tfstate"
export BACKEND_KEY="${TF_VAR_application_name}-${TF_VAR_environment_name}"

# force Terraform to use the workspace-specific CLI config (absolute path to avoid shell cwd quirks)
# this lets provider_installation mirror/dev_overrides in ./terraform.rc take effect
# export TF_CLI_CONFIG_FILE="/d/Work/Azure-Terraform-Windows/source/repos/Terraform101/Lab7/.terraformrc"
# optional: enable INFO logs for provider installation diagnostics
export TF_LOG=INFO

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $* -var-file ./env/$TF_VAR_environment_name.tfvars

rm -rf .terraform