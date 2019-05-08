provider "azurerm" {
  version = "~> 1.19"
}

locals {
  tags = {
    "managed"     = "terraformed"
    "owner"       = "j.mueller@thesolution.at"
    "environment" = "learning"
  }
}
variable "administrator-name" {
    type = "string"
    description = "Azure SQL Server Password"
}
variable "sql_password" {
    type = "string"
    description = "Azure SQL Server Password"
}

resource "azurerm_resource_group" "main" {
  name     = "Jurgen-RG"
  location = "West Europe"
  tags     = "${local.tags}"
}

resource "azurerm_sql_server" "main" {
  name                         = "jurgen-db-srv"
  resource_group_name          = "${azurerm_resource_group.main.name}"
  location                     = "${azurerm_resource_group.main.location}"
  version                      = "12.0"
  administrator_login          = "${var.administrator-name}"
  administrator_login_password = "${var.sql_password}"
  tags                         = "${local.tags}"
}

resource "azurerm_sql_firewall_rule" "main" {
  name                = "AlllowAzureServices"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_sql_server.main.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "main" {
  name                             = "jurgen-DB"
  resource_group_name              = "${azurerm_resource_group.main.name}"
  location                         = "${azurerm_resource_group.main.location}"
  server_name                      = "${azurerm_sql_server.main.name}"
  edition                          = "Standard"
  requested_service_objective_name = "S1"
  tags                             = "${local.tags}"
}
