
#Postgre Service
#Manages a PostgreSQL Database within a PostgreSQL Server
resource "azurerm_postgresql_server" "postgresqlSV" {
  name                = "postgresql-server"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "labadmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "postgresqlDB" {
  name                = "testdb"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresqlSV.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}


