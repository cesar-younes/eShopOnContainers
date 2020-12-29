#Sets computed environment variables required for terrafom remote backend
ESHOP_APP=eshop
ESHOP_ENV=cey
ESHOP_LOCATION=westeurope
ESHOP_LOCATION_SHORT=euwe
ESHOP_ACR_NAME=acreshopeuwe
ESHOP_ACR_RG_NAME=rg-eshop-euwe

ARM_TENANT_ID=#Add Tenant ID
ARM_SUBSCRIPTION_ID=#Add Subscription Id
ARM_USERNAME=#Add Username

#Sets computed input variables for terraform templates
export TF_VAR_env=$ESHOP_ENV
export TF_VAR_location=$ESHOP_LOCATION
export TF_VAR_location_suffix=$ESHOP_LOCATION_SHORT
export TF_VAR_app=$ESHOP_APP
export TF_VAR_acr=$ESHOP_ACR_NAME
export TF_VAR_acr_rg=$ESHOP_ACR_RG_NAME