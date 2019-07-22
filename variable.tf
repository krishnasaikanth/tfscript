variable "resource_g" {
  description = "this would be the name of the resource group"
  
}

variable "location" {
  description = "default value of location in this project"
  default = "West US"
}

variable "virtualnetwork" {
 description = "Name the virtual network"
 default = "NewVnetwork1"
 }

variable "nsg" {
  description = "nsg name"
  default = "NewNSG1"
}

variable "subnet" {
  description = "name of subnet01"
  default = "subnet011"
}
variable "nsgrule" {
description = "network security group rule"
default = "rule1"
}

variable "count" {
description = "number of instanes of a given resource"
default = "2"

}

variable "aznetworkinterface" {

description = "used to name the network interface"
default = "networkintfc1"
}

variable "virtualmachinename" {
  description = "name of the computing resources"
  default = "MainCPU1"
  
  }

variable "username" {
  description = "name of the login username"
  }

variable "password" {
  description = "login password"
  
}

variable "backsub" {
  description = "backend machine subnet group"
  default = "subnet2"
}

variable "NI" {
  description = "backend network interface"
  default = "Nicback1"
}