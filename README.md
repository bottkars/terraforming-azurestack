# terraforming-azurestack

this is a terraform template to deploy  Pivotal Cloud Foundry Operations Manager to AzureStack

it is *NOT* an officially supported Pivotal Template, however, it is aligned to [Terraforming Azure](https://github.com/pivotal-cf/terraforming-azure)

It uses *unmanaged disks* as the terraform provider for AzureStack does not support Custom Managed Images for now.

## requirements

- clone the repo
- download terraform < 0.12
- azurestack <= 1904 ( 1905 is broken with terraform <=0.7.0)


To get started, set the Following Environment Variables:

### Windows:
Terraform Enfironment

```Powershell
$ENV:ARM_ENDPOINT="https://management.local.azurestack.external"
$ENV:ARM_SUBSCRIPTION_ID = <your supscription id>
$ENV:ARM_CLIENT_ID       = <your client id>
$ENV:ARM_CLIENT_SECRET   = <your client secret>
$ENV:ARM_TENANT_ID       = <your tenant id >
$ENV:ARM_LOCATION        = <your azure region>
```

Terraform Deployment Variables
```Powershell
$env:TF_VAR_subscription_id = $ENV:ARM_SUBSCRIPTION_ID
$env:TF_VAR_client_id      = $ENV:ARM_CLIENT_ID
$env:TF_VAR_client_secret  = $ENV:ARM_CLIENT_SECRET
$env:TF_VAR_tenant_id      = $ENV:ARM_TENANT_ID 
$env:TF_VAR_location       = $ENV:ARM_LOCATION
$env:TF_VAR_ops_manager_image_uri      = <url to ops manager image on Azure or local Stack"
````

### linux/osx

Tearraform Environment

```bash
export ARM_ENDPOINT="https://management.local.azurestack.external"
export ARM_SUBSCRIPTION_ID = <your supscription id>
export ARM_CLIENT_ID       = <your client id>
export ARM_CLIENT_SECRET   = <your client secret>
export ARM_TENANT_ID       = <your tenant id >
export ARM_LOCATION        = <your azure region>
```

Terraform Deployment Variables

```bash
export TF_VAR_subscription_id = ${ARM_SUBSCRIPTION_ID}
export TF_VAR_client_id      = ${ARM_CLIENT_ID}
export TF_VAR_client_secret  = ${ARM_CLIENT_SECRET}
export TF_VAR_tenant_id      = ${ARM_TENANT_ID}
export TF_VAR_location       = ${ARM_LOCATION}
export TF_VAR_ops_manager_image_uri = <url to ops manager image on Azure or AzureStack>
```


create a terraform.tfvars in terraforming-pas with the following content: 
(or use additional environemnt variables)

[example](./terraform.tfvars.example)
```
env_name              = "banana"
dns_suffix            = "westus.stackpoc.com"
env_short_name        = "fruit"
```
run the following:

```bash
cd to terraforming-pas
terraform init
terraform apply
```

