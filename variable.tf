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

variable "backsub" {
  description = "backend machine subnet group"
  default = "subnet2"
}

variable "nsgrule" {
description = "network security group rule"
default = "rule1"
}

variable "aznetworkinterface" {
description = "used to name the network interface"
default = "networkintfc1"
}

variable "aznetworkinterface2" {
description = "used to name the network interface"
default = "networkintfc2"
}

variable "frontend" {
  description = "name of the computing resources"
  default = "JumpServer"
}

variable "backend" {
  description = "name of the computing resources"
  default = "Appserver"
}

variable "disk" {
description = "name of os disk"
default = "disk0"
}

variable "username" {
  description = "name of the login username"
  }

variable "password" {
  description = "login password"
  
}

variable "username1" {
  description = "name of the login username"
  }

variable "password1" {
  description = "login password"
}

variable "NI" {
  description = "backend network interface"
  default = "Nicback1"
}