# Variables for Azure resources
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

 

variable "location" {
  description = "Azure region"
  type        = string
}

 

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

 

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

 

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

 

variable "aks_subnet_address_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = string
  default     = "10.0.1.0/24"
}

 

variable "appgw_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
}

 

variable "appgw_subnet_address_prefix" {
  description = "Address prefix for the Application Gateway subnet"
  type        = string
  default     = "10.0.2.0/24"
}

 

variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
}

 

variable "db_subnet_address_prefix" {
  description = "Address prefix for the database subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks"
}

 

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aks-dns"
}

 

variable "aks_node_resource_group" {
  description = "Name of the resource group for AKS nodes"
  type        = string
}

 

variable "aks_kubernetes_version" {
  description = "Version of Kubernetes to use"
  type        = string
  default     = "1.21.1"
}

 

variable "aks_service_cidr" {
  description = "CIDR block for the AKS services"
  type        = string
  default     = "10.1.0.0/16"
}

 

variable "aks_dns_service_ip" {
  description = "IP address for the AKS DNS service"
  type        = string
  default     = "10.0.0.10"
}

 

variable "aks_docker_bridge_cidr" {
  description = "CIDR block for the AKS Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

 

variable "aks_lb_sku" {
  description = "SKU for the AKS load balancer"
  type        = string
  default     = "Standard"
}
