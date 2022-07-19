
variable "location" {
  type    = string
  default = "southeastasia"
}

variable "prefix" {
    type = string
    default = "demo"
}

variable "ssh_source_address" {
    type = string
    default = "*"
}

variable "vm_size" {
    type = string
    default = "Standard_B1s"
}

variable "zones" {
    type =  list(string)
    default = []
}

variable "common_remote_state_account" {
    type = string
    default = "cmnttfstate"
}

variable "common_remote_state_container" {
    type = string
    default = "tfstate"
}

variable "common_remote_state_key" {
    type = string
    default = "cmn.state.demo"
}

variable "common_remote_state_resource_group_name" {
    type = string
    default = "cmn-scus-rg"
}