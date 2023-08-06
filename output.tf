output "aks_cluster_kube_config" {
  value = azurerm_kubernetes_cluster.my_aks_cluster.kube_config_raw
}
