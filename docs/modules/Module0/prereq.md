---
title: Pre-requisites
parent: Module 0 - Introduction and Pre-requisites
has_children: false
nav_order: 2
---

# Pre-requisites

## Requirements

* Azure Subscription (if you don't have one, you can create a free account [here](https://azure.microsoft.com/en-us/free/))
* Azure CLI (if you don't have one, you can install it [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
* Github Account (if you don't have one, you can create one [here](https://github.com)

## Infrastructure Deployment via GitHub Actions using OpenID Connect and Bicep (IaC)

For this workshop, we will be using GitHub Actions using OpenID Connect and Infrastructure-as-Code (IaC) using Bicep to deploy the AKS cluster, to derive following benefits:

* Infrastructure-as-Code (IaC) - Infrastructure is defined as code, and can be version controlled and reviewed. 
* OpenID Connect - OpenID Connect is an authentication protocol that allows you to connect securely to Azure resources using your GitHub account.
* GitHub Actions - GitHub Actions is a feature of GitHub that allows you to automate your software development workflows.
* Bicep - Bicep is a Domain Specific Language (DSL) for deploying Azure resources declaratively. It aims to drastically simplify the authoring experience with a cleaner syntax, improved type safety, and better support for modularity and code re-use.

This will require performing the following tasks:

1. Forking this repository into your GitHub account 
2. Creating an Azure Resource Group
3. Configuring OpenID Connect in Azure.
4. Setting Github Actions secrets
5. Enabling the GitHub Actions workflow

### Forking this repository into your GitHub account

* Fork this [repository](https://github.com/ahmedbham/azure-openai-api-levelup) into your GitHub account by clicking on the "Fork" button at the top right of its page.
* Clone your newly forked repository to your local machine.


### Creating an Azure Resource Group

```bash
az login
resourceGroupName="openai-levelup"
location="eastus"
az group create --name $resourceGroupName --location $location
```

### Configuring OpenID Connect in Azure

* execute [aad-federated-cred.sh]() bash file in your local machine, passing your github username as the argument.

```bash
./aad-federated-cred.sh <github-username>
```

* note the appId echoed by the script for next step

### Setting Github Actions secrets

1. Open your forked Github repository and click on the `Settings` tab.
2. In the left-hand menu, expand `Secrets and variables`, and click on `Actions`.
3. Click on the `New repository secret` button for each of the following secrets:
   * `AZURE_SUBSCRIPTION_ID`(run `az account show --query id -o tsv` to get the value)
   * `AZURE_TENANT_ID` (run `az account show --query tenantId --output tsv` to get the value)
   * `AZURE_CLIENT_ID` (this is the `appId` from running the previous step)
   * `AZURE_RESOURCE_GROUP` (this is the `resourceGroupName` from earlier step)

### Enable GitHub Actions workflow

* Enable GitHub Actions for your repository by clicking on the "Actions" tab, and clicking on the `I understand my workflows, go ahead and enable them` button.

