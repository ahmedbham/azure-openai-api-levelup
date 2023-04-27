// Declare parameters
@description('The unique name for the Azure Storage Account.')
param storageAccountName string = 'opai${uniqueString(resourceGroup().id)}'

@description('The unique name for the Azure Function App.')
param functionAppName string = 'xact-classifier-openai-${uniqueString(resourceGroup().id)}'

// Optional params
@description('The region to deploy the cluster. By default this will use the same region as the resource group.')
param location string = resourceGroup().location

// Declare variables
var storageAccountType = 'Standard_LRS'
var appServicePlanSku = 'S1'

// Create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}


// Create storage containers
resource classificationContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'classification'
  parent: blobService
 
  properties: {
    publicAccess: 'Blob'
  }
}

resource outputContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'output'
  parent: blobService
  properties: {
    publicAccess: 'Blob'
  }
}

// Create app service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: appServicePlanSku
    tier: 'Standard'
  }
}

// Create function app
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppName
        }
        {
          name: 'STORAGE_ACCOUNT_CONNECTION_STRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'OPENAI_API_BASE'
          value: 'Enter your Azure OpenAI API Endpoint URL'
        }
        {
          name: 'OPENAI_API_KEY'
          value: 'Enter your Azure OpenAI API Key'
        }
        {
          name: 'OPENAI_API_MODEL'
          value: 'text-davinci-003'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}




