---
title: Lab 
parent:  Module 2 - Azure OpenAI and Cognitive Search
has_children: false
nav_order: 2
---

## Installation

### Preferred CLI Environment for this lab

It's easiest to run the lab instructions using [Azure Cloud Shell](https://shell.azure.com). 

### Project Initialization

1. Create a new folder `lab2` and switch to it in the terminal

  ```bash
  mkdir lab2
  cd lab2
  ```

1. Run the following command:

```bash
azd login
```

   > [!NOTE]
   > if you are using a non-Microsoft account, and if running CodeSpaces or Cloud Shell, you will need to run:
   >
   > `azd login --use-device-code=false --tenant-id <your tenant id>`
   >
   > to obtain `<your tenant id>` run `az account show --query tenantId -o tsv`
   > 
   > You may receive an error with message `localhost refused to connect` after logging in. If so:
   > 
   > 1. Copy the URL.
   > 1. Run `curl '<pasted url>'` (URL in quotes) in a new CodeSpaces or Cloud Shell terminal.
   > 
   > In the original CodeSpaces or Cloud Shell terminal, the login should now succeed.

1. Run the following command:

```bash
azd config set defaults.subscription <yourSubscriptionID>
```

to obtain `<yourSubscriptionID>`, run `az account show --query id -o tsv`

1. Run the following command:

```bash
azd init -t azure-search-openai-demo
```

    * For the target location, the regions that currently support the models used in this sample are **East US** or **South Central US**. For an up-to-date list of regions and models, check [here](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
    * when prompted with `? Please enter a new environment name:`, enter `dev`

    > [!NOTE]

    > If you would like re-use your existing open ai deployemnt, please set azd env set AZURE_OPENAI_SERVICE {Name of existing > OpenAI service}
    
    > Run `azd env set AZURE_OPENAI_SERVICE {Name of existing OpenAI service}`

1. Execute the following command:

```bash
azd up
```

  * This will provision Azure resources and deploy this sample to those resources, including building the search index based on the files found in the ./data folder.
  * After the application has been successfully deployed you will see a URL printed to the console. Click that URL to interact with the application in your browser.

  * It will look like the following:
  ![Endpoint](../../assets/images/module2/endpoint.png)

> NOTE: It may take a minute for the application to be fully deployed. If you see a "Python Developer" welcome screen, then wait a minute and refresh the page.

Once in the web app:

* Try different topics in chat or Q&A context. For chat, try follow up questions, clarifications, ask to simplify or elaborate on answer, etc.
* Explore citations and sources
* Click on "settings" to try different options, tweak prompts, etc.
