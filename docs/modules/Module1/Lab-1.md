---
title: Lab
parent:  Module 1 - Transaction Classification Application
has_children: false
nav_order: 2
---

# Module 1: Lab - Transaction Classification Application

In this lab, you will create a transaction classification application that uses the Azure OpenAI API and other Azure services to classify a public dataset of transactions into a number of categories that we have predefined. These approaches should be replicable to any multiclass classificaiton use case where we are trying to fit transactional data into predefined categories, and by the end of running through this you should have an approach for dealing with unlabelled datasets.

## Installation

This module requires creation of following Azure resources
  1. An Azure Storage Account and two containers: 
    1. "classification" - for the transaction file
    2. "output" - for the results
  2. An Azure Function App Resource
  3. Building and Deploying the Azure Function App code
  4. An Event Grid Subscription to the Azure Function App Resource from the Azure Storage Account for "Blob Created" events

### Creating an Azure Resource Group

```bash
az login
export resourceGroupName="openai-levelup-rg"
export location="eastus"
az group create --name $resourceGroupName --location $location
```

   > [!NOTE]
   > if you are using a non-Microsoft account, and if running CodeSpaces in the browser, you may receive an error with message `localhost refused to connect` after logging in. If so:
   > 
   > 1. Copy the URL.
   > 1. Run `curl '<pasted url>'` (URL in quotes) in a new Visual Studio Code terminal.
   > 
   > In the original terminal, the login should now succeed.
   > Run `az account set -s <your-subscription-id>`

### Creating an Azure Storage Account and two containers, and an Azure Function App Resource

This is done by executing [module2-infra.bicep](../../../tools/deploy/Module1/infra/module1-infra.bicep) Bicep template file as follows:

```bash
az deployment group create --resource-group $resourceGroupName --template-file tools/deploy/module1/infra/module1-infra.bicep
```

### Building and Deploying the Azure Function App code

* Deploy the Azure Function App code as follows:
  1. In Azure portal, navigate to the Function App that was deployed in the last step.
  2. Click **Get publish profile** and download **.PublishSettings** file.
  3. Open the **.PublishSettings** file and copy the XML content.
  4. Paste the XML content to a variable **AZURE_FUNCTIONAPP_PUBLISH_PROFILE**
  5. Run the following command to build the Azure Function App code:
  
  ```bash
  cd tools/deploy/module1/TransactionClassifier
  appName=$(az functionapp list --resource-group $resourceGroupName --query "[].name" -o tsv)
  func azure functionapp publish $appName --publish-profile $AZURE_FUNCTIONAPP_PUBLISH_PROFILE --force
  ```

* Configure following **Application Settings** for the Azure Function by going to your `function app > Configuration > Application Settings`:
  1. OPENAI_API_BASE - Azure OpenAI API Endpoint URL (e.g. https://openai-demo-ahmedbham.openai.azure.com/)
  2. OPENAI_API_KEY - Azure OpenAI API Key
  3. OPENAI_API_MODEL - "text-davinci-003" (set it equal to the `model name` you provided when deploying the `text-davinci-003` **model** in Azure OpenAI Studio)

* Create an `Event Grid Subscription` to the Azure Function App Resource from the Azure Storage Account for "Blob Created" events in Azure portal:
  1. Navigate to your `storage account > Events > + Event Subscription`
  2. Set `Event Schema` to `Event Grid Schema``
  3. Set `System Topic Name` to `classification`
  4. Select only `Blob Created` event type
  5. Select`Function App` as the `Endpoint Type`
  6. Set `Endpoint`value by selecting the correct `Subscription`, `Resource Group`, `Function App`, `Slot`, and `Function` from the dropdowns
  7. Click `Create` to create the subscription

![Event Grid Subscription Page](../../assets/images/module1/module1-create-event-subscription.png)

* Open the sample transaction file [25000_spend_dataset_current_25.csv](../../../tools/deploy/Module1/data/25000_spend_dataset_current_25.csv) and notice that the **classification** column is empty. This is the column that will be populated by the Azure Function by calling Azure OpenAI API.   	
* Upload this file to the **classification** blob container: `portal > storage account > containers > classification > upload`
* After few seconds, download the updated file from the **output** blob container `portal > storage account > containers > output > download`
* Open the file and notice the **classification** column is populated with the predicted category for each transaction.

resource systemTopic 'Microsoft.EventGrid/systemTopics@2021-12-01' = {
  name: 'classification'
  location: location
  properties: {
    source: storageAccount.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

var prefix = 'https://'
var hostName = functionApp.properties.defaultHostName
var endpointUrl = '${prefix}${hostName}'

// Create event grid subscription
resource eventGridSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  name: 'storage-account-blob-created'
  parent: systemTopic
  properties: {
    destination: {
      endpointType: 'WebHook'
      properties: {
        endpointUrl: endpointUrl
        // resourceId: resourceId('Microsoft.Web/sites', functionApp.name)
              }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
      ]
      
    }
  }
}