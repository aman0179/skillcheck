terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
resource "azurerm_resource_group" "rg-skill" {
  name     = azurerm_resource_group.rg-skill.name
  location = var.location
}

 

resource "azurerm_virtual_network" "vnet" {
  name                = "azurerm_virtual_network.vnet.name-${azurerm_resource_group.rg-skill.name}"
  address_space       = var.vnet_address_space
  resource_group_name = azurerm_resource_group.rg-skill.name
  location            = azurerm_resource_group.rg-skill.location
}

 

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.rg-skill.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = [var.aks_subnet_prefix]
}

 

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "${var.appgw_subnet_name}-${azurerm_resource_group.rg-skill.name}"
  resource_group_name  = azurerm_resource_group.rg-skill.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_prefix]
}

 

resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.db_subnet_name}-${azurerm_resource_group.rg-skill.name}"
  resource_group_name  = azurerm_resource_group.rg-skill.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.db_subnet_prefix]
}

 

resource "azurerm_kubernetes_cluster" "aks" {
  name                   = var.aks_cluster_name-${azurerm_resource_group.rg-skill.name}
  location               = azurerm_resource_group.rg-skill.location
  resource_group_name    = azurerm_resource_group.rg-skill.name
  dns_prefix             = var.aks_dns_prefix
  node_resource_group    = var.aks_node_resource_group
  kubernetes_version     = var.aks_kubernetes_version
  service_cidr           = var.aks_service_cidr
  dns_service_ip         = var.aks_dns_service_ip
  docker_bridge_cidr     = var.aks_docker_bridge_cidr
  network_plugin         = "azure"
  load_balancer_sku      = var.aks_lb_sku
  network_profile_subnet_id = azurerm_subnet.aks_subnet.id
}

 

resource "azurerm_application_gateway" "agw" {
  name                = "${var.appgw_name}-${azurerm_resource_group.rg-skill.name}"
  resource_group_name = azurerm_resource_group.rg-skill.name
  location            = azurerm_resource_group.rg-skill.location
  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_sku_capacity
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }
  frontend_port {
    name = "appGatewayFrontendPort"
    port = var.appgw_frontend_port
  }
  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = var.appgw_public_ip_id
  }
  backend_address_pool {
    name = "appGatewayBackendPool"
    fqdns = var.appgw_backend_pool_fqdns
  }
  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "appGatewayFrontendPort"
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "appGatewayRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "appGatewayHttpListener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "appGatewayBackendHttpSettings"
  }
  backend_http_settings {
    name                  = "appGatewayBackendHttpSettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 120
  }
}

 
resource "azurerm_sql_server" "my_sql_server" {
  name                         = "${var.sql_server_name}-${azurerm_resource_group.rg-skill.name}"
  resource_group_name          = azurerm_resource_group.rg-skill.name
  location                     = azurerm_resource_group.rg-skill.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
}

 

resource "azurerm_sql_database" "my_sql_database" {
  name                = "${var.sql_database_name}-${azurerm_resource_group.rg-skill.name}"
  resource_group_name = azurerm_resource_group.rg-skill.name
  location            = azurerm_resource_group.rg-skill.location
  server_name         = azurerm_sql_server.my_sql_server.name
  edition             = var.sql_database_edition
  collation           = var.sql_database_collation
}

 

output "aks_cluster_kube_config" {
  value = azurerm_kubernetes_cluster.my_aks_cluster.kube_config_raw
}
