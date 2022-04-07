/*-----------------------Create ACR--------------------------------------------*/



resource "azurerm_container_registry" "acrk8s" {



  name                = "nghiattracrk8s"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "Australia East"
  sku                 = "Standard"
  //Each container registry contains an admin user account that is disabled by default
  admin_enabled = false

}

/*-----------------------Create AKS--------------------------------------------*/

resource "azurerm_kubernetes_cluster" "k8s-cluster" {

  name                = "azure-aks"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-prefix-aks"



  default_node_pool {

    name                = "default"
    node_count          = 1
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
    vm_size             = "Standard_B2s"

  }


  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

}

# add the role to the identity the kubernetes cluster was assigned

resource "azurerm_role_assignment" "role-aks" {

  principal_id                     = azurerm_kubernetes_cluster.k8s-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acrk8s.id
  skip_service_principal_aad_check = true

}