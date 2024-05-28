

variable "rg" {
  type = string
}

variable "vnet" {
  type = string
}

variable "vm-name" {
  type = string
}

variable "subnet" {
  type = string
}

variable "name" {
  type    = string
  default = "temi"
}

variable "pass" {
  type    = string
  default = "Olanike@1973"
}

variable "nic" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet-add" {
  type = list(string)
}

variable "sub-add" {
  type = list(string)
}