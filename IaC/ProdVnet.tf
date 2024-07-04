resource "azurerm_resource_group" "prodrg" {
  name     = "${var.purpose}-RG"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.purpose}_VNET"
  address_space       = [var.vnetaddress]
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  tags                = var.tags
}

resource "azurerm_subnet" "frontendsubnet" {
  name                 = "${var.purpose}_frontendsubnet"
  resource_group_name  = azurerm_resource_group.prodrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.frontendsubnetaddress]
}
resource "azurerm_subnet" "backendsubnet" {
  name                 = "${var.purpose}_backendsubnet"
  resource_group_name  = azurerm_resource_group.prodrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.backendsubnetaddress]
}
resource "azurerm_subnet" "dbsubnet" {
  name                 = "${var.purpose}_dbSubnet"
  resource_group_name  = azurerm_resource_group.prodrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.dbsubnetaddress]
}
resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.prodrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.AzureBastionSubnet]
}
resource "azurerm_nat_gateway" "natgateway" {
  name                    = "${var.purpose}_prodnatgateway"
  location                = azurerm_resource_group.prodrg.location
  resource_group_name     = azurerm_resource_group.prodrg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}
resource "azurerm_public_ip" "natgwip" {
  name                = "${var.purpose}_prodnatpip"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_nat_gateway_public_ip_association" "natgatewayiplink" {
  nat_gateway_id       = azurerm_nat_gateway.natgateway.id
  public_ip_address_id = azurerm_public_ip.natgwip.id
}
resource "azurerm_subnet_nat_gateway_association" "natbackendsubnetlink" {
  subnet_id      = azurerm_subnet.backendsubnet.id
  nat_gateway_id = azurerm_nat_gateway.natgateway.id

}
# NSG For the frontend Subnet
resource "azurerm_network_security_group" "nsgprodfrontend" {
  name                = "${var.purpose}_NSG-frontend"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  tags                = var.tags
    security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_ranges    = ["443"]
    source_address_prefixes    = ["111.111.111.111"]
    destination_address_prefix = "*"
  }
}
# NSG for DB Subnet
resource "azurerm_network_security_group" "nsgdb" {
  name                = "${var.purpose}_NSG-DB"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  tags                = var.tags
}
# NSG For the backend Subnet
resource "azurerm_network_security_group" "nsgprodbackend" {
  name                = "${var.purpose}_NSG-backend"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  tags                = var.tags
}
resource "azurerm_subnet_network_security_group_association" "frontnsglink" {
  subnet_id                 = azurerm_subnet.frontendsubnet.id
  network_security_group_id = azurerm_network_security_group.nsgprodfrontend.id
}
resource "azurerm_subnet_network_security_group_association" "backnsglink" {
  subnet_id                 = azurerm_subnet.backendsubnet.id
  network_security_group_id = azurerm_network_security_group.nsgprodbackend.id
  depends_on                = [azurerm_subnet_nat_gateway_association.natbackendsubnetlink]
}
resource "azurerm_subnet_network_security_group_association" "dbnsglink" {
  subnet_id                 = azurerm_subnet.dbsubnet.id
  network_security_group_id = azurerm_network_security_group.nsgdb.id
}

resource "azurerm_public_ip" "bastionIP" {
  name                = "examplepip"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "examplebastion"
  location            = azurerm_resource_group.prodrg.location
  resource_group_name = azurerm_resource_group.prodrg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastionIP.id
  }
}