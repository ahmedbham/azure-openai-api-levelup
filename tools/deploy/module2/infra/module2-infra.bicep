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
var appServicePlanSku = 'F1'

// Create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
}

// Create storage containers
resource classificationContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01-preview' = {
  name: 'classification'
  dependsOn: [storageAccount]
  properties: {
    publicAccess: 'Blob'
  }
}

resource outputContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01-preview' = {
  name: 'output'
  dependsOn: [storageAccount]
  properties: {
    publicAccess: 'Blob'
  }
}

// Create app service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: appServicePlanSku
    tier: 'Free'
    size: 'F1'
  }
}

// Create function app
resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  dependsOn: [appServicePlan]
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=[account_key];EndpointSuffix=core.windows.net'
        }
      ]
    }
  }
}

// Create event grid subscription
resource eventGridSubscription 'Microsoft.EventGrid/eventSubscriptions@2021-06-01-preview' = {
  name: 'storage-account-blob-created'
  dependsOn: [storageAccount, functionApp]
  properties: {
    destination: {
      endpointType: 'WebHook'
      properties: {
        endpointUrl: '${functionApp.properties.defaultHostName}/runtime/webhooks/eventgrid?functionName=[function_name]'
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
      ]
      subjectBeginsWith: '/blobServices/default/containers/classification/'
    }
  }
}



