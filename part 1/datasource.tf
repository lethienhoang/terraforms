# data "terraform_remote_state" "common" {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = var.common_remote_state_resource_group_name
#     storage_account_name = var.common_remote_state_account
#     container_name       = var.common_remote_state_container
#     key                  = var.common_remote_state_key
#   }
# }
