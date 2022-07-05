
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