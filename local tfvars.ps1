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




export ARM_CLIENT_SECRET="m1;^y:1nV]%cM.s/]$]};_=["
export ARM_SUBSCRIPTION_ID=57230479-98a0-4777-a763-8c024866a52a
export ARM_ENDPOINT=https://management.local.azurestack.external
export ARM_TENANT_ID=5f7dfed5-1a3d-424f-8e22-4661ae54b53b
export ARM_CLIENT_ID=528621af-bbbb-44a8-bc62-3a2db31b0f62
export ARM_LOCATION=local


export TF_VAR_ops_manager_image_uri=https://opsmanagerimage.blob.local.azurestack.external/images/ops-manager-2.5.4-build.189.vhd
export TF_VAR_subscription_id=57230479-98a0-4777-a763-8c024866a52a
export TF_VAR_client_secret="m1;^y:1nV]%cM.s/]$]};_=["
export TF_VAR_tenant_id=5f7dfed5-1a3d-424f-8e22-4661ae54b53b
export TF_VAR_location=local
export TF_VAR_client_id=528621af-bbbb-44a8-bc62-3a2db31b0f62