#Set Environment Variables for Azure RM Terraform
$env:Path="$env:Path;$HOME\om"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$ENV:ARM_ENDPOINT="https://management.local.azurestack.external"
$ENV:ARM_SUBSCRIPTION_ID = (Get-AzureRmSubscription).id
$ENV:ARM_CLIENT_ID       = $env_vars.client_id
$ENV:ARM_CLIENT_SECRET   = $env_vars.client_secret
$ENV:ARM_TENANT_ID       = (Get-AzureRmSubscription).TenantId
$ENV:ARM_LOCATION        = "local"

# $GLOBAL:TF_VAR_ENDPOINT="https://management.local.azurestack.external"
$env:TF_VAR_subscription_id = (Get-AzureRmSubscription).id
$env:TF_VAR_client_id      = $env_vars.client_id
$env:TF_VAR_client_secret  = $env_vars.client_secret
$env:TF_VAR_tenant_id      = (Get-AzureRmSubscription).TenantId
$env:TF_VAR_location       = "local"
$env:TF_VAR_ops_manager_image_uri      = "https://opsmanagerimage.blob.local.azurestack.external/images/ops-manager-2.6.3-build.163.vhd"




export ARM_CLIENT_SECRET="redacted"
export ARM_SUBSCRIPTION_ID=redacted
export ARM_ENDPOINT=https://management.local.azurestack.external
export ARM_TENANT_ID=redacted
export ARM_CLIENT_ID=redacted
export ARM_LOCATION=local


export TF_VAR_ops_manager_image_uri=https://opsmanagerimage.blob.local.azurestack.external/images/ops-manager-2.6.3-build.163.vhd
export TF_VAR_subscription_id=redacted
export TF_VAR_client_secret=redacted
export TF_VAR_tenant_id=redacted
export TF_VAR_location=local
export TF_VAR_client_id=redacted