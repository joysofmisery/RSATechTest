variable "tags" {
  type = map(any)
  default = {
    "Created By" = "amit.singh3@smartenergywater.in"
    ENV          = "Prod"
    Client       = "CityofDanville"
    "Created On" = "1 July 2024"
  }
}

variable "vnetaddress" {
  type    = string
  default = ""
}

variable "frontendsubnetaddress" {
  type    = string
  default = ""
}
variable "backendsubnetaddress" {
  type    = string
  default = ""
}
variable "dbsubnetaddress" {
  type    = string
  default = ""
}
variable "AzureBastionSubnet" {
  type    = string
  default = ""
}
variable "purpose" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}