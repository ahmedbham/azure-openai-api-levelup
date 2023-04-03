---
title: Lab - Transaction Classification Application
parent:  Module 2 - Transaction Classification Application
has_children: false
nav_order: 1
---

# Module 2: Lab - Transaction Classification Application

In this lab, you will create a transaction classification application that uses the Azure OpenAI API and other Azure services to classify a public dataset of transactions into a number of categories that we have predefined. These approaches should be replicable to any multiclass classificaiton use case where we are trying to fit transactional data into predefined categories, and by the end of running through this you should have an approach for dealing with unlabelled datasets.

## Installation

* This module requires creation of following Azure resources
  1. An Azure Storage Account and two containers: 
    1. "classification" - for the transaction file
    2. "output" - for the results
  2. An Azure Function App Resource
  3. An Event Grid Subscription to the Azure Function App Resource from the Azure Storage Account for "Blob Created" events
  * This will be accomplished by running Github Actions workflow [module2-infra-worflow.yaml](../../../.github/workflows/module2-infra-workflow.yaml) which deploys [module2-infra.bicep](../../../tools/deploy/Module2/infra/module2-infra.bicep) to your Azure Subscription
    * To trigger this workflow manually:
      * click on the `Actions` tab.
      * Select `.github/workflows/module2-infra-worflow.yaml`.
      * Click on the `Run workflow` button
* Deploy the Azure Function App code using Github Actions workflow [module2-code-workflow.yaml](../../../.github/workflows/module2-code-workflow.yaml) 
  1. In Azure portal, go to your function app that was deployed in the last step.
  2. Click **Get publish profile** and download **.PublishSettings** file.
  3. Open the **.PublishSettings** file and copy the content.
  4. Paste the XML content to your GitHub Repository > Settings > Secrets > Add a new secret > **AZURE_FUNCTIONAPP_PUBLISH_PROFILE**
  5. To trigger this workflow manually:
    * click on the `Actions` tab.
    * Select `.github/workflows/module2-code-worflow.yaml`.
    * Click on the `Run workflow` button
* Create following Application Settings for the Azure Function by going to your function app > Configuration > Application Settings > New application setting
  1. OPENAI_API_BASE - Azure OpenAI API Endpoint URL (e.g. https://openai-demo-ahmedbham.openai.azure.com/)
  2. OPENAI_API_KEY - Azure OpenAI API Key
  3. OPENAI_API_MODEL - "text-davinci-003"
  4. STORAGE_ACCOUNT_CONNECTION_STRING - Connection string for the storage account that was deployed in the first step (azure portal > storage account > access keys > connection string)
  	
* Upload the sample transaction file [25000_spend_dataset_current_25.csv](../../../tools/deploy/Module2/data/25000_spend_dataset_current_25.csv) to the "classification" container (portal > storage account > containers > classification > upload)
* View the results in the "output" container (portal > storage account > containers > output > view blobs)
  * Download the file and open in Excel to view the results