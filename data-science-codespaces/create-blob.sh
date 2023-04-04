# Variables for storage
let "randomIdentifier=$RANDOM*$RANDOM"
location="East US"
resourceGroup="codespace-workshop-rg-$randomIdentifier"
storage="csblobstg$randomIdentifier"
container="data"

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location"

# Create a general-purpose standard storage account
echo "Creating $storage..."
az storage account create --name $storage --resource-group $resourceGroup --location "$location" --sku Standard_RAGRS --encryption-services blob

# List the storage account access keys
az storage account keys list \
    --resource-group $resourceGroup \
    --account-name $storage 

echo "Creating blob container named data in $storage..."
az storage container create -n $container --public-access blob --account-name $storage

az storage azcopy blob upload -c $container --account-name $storage -s data-science-codespaces/data/US-pumpkins-clean.csv

az storage account show  -n $storage --query "{STORAGEACCOUNTURL:primaryEndpoints.blob}"

az storage account keys list -n $storage --query "[0].{STORAGEACCOUNTKEY:value}"

rm -rf data-science-codespaces/data/US-pumpkins-clean.csv