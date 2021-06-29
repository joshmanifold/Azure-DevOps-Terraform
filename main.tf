# terraform {
#   required_providers {
#     azurerm = {
#       # The "hashicorp" namespace is the new home for the HashiCorp-maintained
#       # provider plugins.
#       #
#       # source is not required for the hashicorp/* namespace as a measure of
#       # backward compatibility for commonly-used providers, but recommended for
#       # explicitness.
#       source  = "hashicorp/azurerm"
#       version = "~> 2.5.0"
#       features {}
#     }
#   }
# }

#TODO: Revisit Role Assignments. 52:30 Azure DevOps: Provision API Infrastrcture using Terraform

terraform {
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "2.5.0"
        }
    }
    backend "azurerm" {
        resource_group_name = "tf_rg_blobstore"
        storage_account_name = "tfstoragemanifold"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
}

variable "imagebuild" {
    type = string
    description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "North Central US"
}

resource "azurerm_container_group" "tfcg_test" {
    name = "weatherapi"
    location = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name
    ip_address_type = "public"
    dns_name_label = "joshmanifoldwa"
    os_type = "Linux"
    container {
        name = "weatherapi"
        image = "joshmanifold/weatherapi:${var.imagebuild}"
        cpu = "1"
        memory = "1"
        ports {
            port = 80
            protocol = "TCP"
        }
    }
}