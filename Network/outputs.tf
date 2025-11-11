output "ad_subnet_id" {
  value       = azurerm_subnet.ad.id
  description = "ID of the AD subnet to use for domain controllers"
}
