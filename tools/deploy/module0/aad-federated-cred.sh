# set github user name from command line argument
github_username=$1
if [ -z "$github_username" ]; then
	echo "Usage: $0 github_username"
	exit 1
fi

resourceGroupName=$2
if [ -z "$resourceGroupName" ]; then
	resourceGroupName=openai-levelup-rg
fi

sed -i "s/your-github-username/$github_username/g" tools/deploy/module0/credential.json

# Create an Azure AD application
uniqueAppName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10 ; echo '')
appId=$(az ad app create --display-name $uniqueAppName --query appId --output tsv)
echo "appId is $appId"

# Create a service principal for the Azure AD app.
assigneeObjectId=$(az ad sp create --id $appId --query id --output tsv)

# Create a role assignment for the Azure AD app.
subscriptionId=$(az account show --query id --output tsv)
az role assignment create --role Contributor --subscription $subscriptionId --assignee-object-id  $assigneeObjectId --assignee-principal-type ServicePrincipal --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName

# Create a federated identity credential on the Azure AD app.
az ad app federated-credential create --id $appId --parameters tools/deploy/module0/credential.json

