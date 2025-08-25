variable "prefix" {
    default = "realTech"
    type = string  
}


variable "function_app_name" {
  default = "realtech-func-demo"
  type    = string
}
resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = "canadacentral"
}
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "as" {
  name                = "${var.prefix}-webapp"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
}

resource "azurerm_app_service_slot" "slot" {
  name                = "${var.prefix}-staging"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
  app_service_name    = "${azurerm_app_service.as.name}"
}
# 🔹 Storage account for Function App
resource "azurerm_storage_account" "storage" {
  name                     = lower("${var.prefix}stor123")   # force lowercase
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# 🔹 Service plan for Function App (Consumption)
resource "azurerm_service_plan" "plan" {
  name                = "${var.prefix}-func-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1" # Y1 = Consumption plan for Functions
}

# Function App
resource "azurerm_linux_function_app" "function" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    "AzureWebJobsStorage"         = azurerm_storage_account.storage.primary_connection_string
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "FUNCTIONS_WORKER_RUNTIME"    = "node"
  }
}
# Service Bus Namespace (for context)
resource "azurerm_servicebus_namespace" "sb" {
  name                = "${var.prefix}-sbns"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# Updated Service Bus Topic
resource "azurerm_servicebus_topic" "topic" {
  name         = "clitopic"
  namespace_id = azurerm_servicebus_namespace.sb.id

  partitioning_enabled        = true
  batched_operations_enabled = true
  express_enabled            = false
}

# Service Bus Subscription (no change here)
resource "azurerm_servicebus_subscription" "sub" {
  name                = "cliSubscription"
  topic_id            = azurerm_servicebus_topic.topic.id
  max_delivery_count  = 10
  lock_duration       = "PT1M"
}

