provider "azurerm" {
    features {}
}

provider "azuread" {
}

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 2"
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 2"
        }
    }
}



// Example for subscription owner as PIM role
resource "azuread_group" "subscription_owner_group_1" {
    display_name     = "subscription_owner_group_1"
    mail_enabled     = false
    security_enabled = true
}

module "pim_assignment_1" {
    source = "./PIM Assignment - Subscription"

    principal_id = azuread_group.subscription_owner_group_1.object_id
    role_definition_name = "Owner"
}


// Example for contributor role on resource group
resource "azuread_group" "rg_contributor_group_1" {
    display_name     = "rg_contributor_group_1"
    mail_enabled     = false
    security_enabled = true
}

resource "azurerm_resource_group" "rg1" {
    name = "rg1"
    location = "westeurope"
}

module "pim_assignment_2" {
    source = "./PIM Assignment - Resource Group"

    resource_group_name  = azurerm_resource_group.rg1.name
    principal_id         = azuread_group.rg_contributor_group_1.object_id
    role_definition_name = "Contributor"
}