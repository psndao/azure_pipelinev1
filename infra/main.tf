resource "random_string" "suffix" {
  length  = 4
  lower   = true
  upper   = false
  numeric = true
  special = false
}

locals {
  # normalise: minuscule + supprime tout ce qui n'est pas [a-z0-9]
  project_norm   = lower(replace(var.project, "[^a-z0-9]", ""))
  sa_prefix      = substr("st${local.project_norm}dev", 0, 20) # garde de la place pour le suffixe
  sa_name        = "${local.sa_prefix}${random_string.suffix.result}"
  rg_name        = "rg-${var.project}-dev"
  container_name = "data"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                            = local.sa_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = local.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
