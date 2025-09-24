variable "project_id" {
  type = string
  default = "talant-1-471921"
}

# variable "regions" {
#   description = "tlnt-network-2 regions"
#   type        = list(string)
#   default     = ["us-central1", "us-east1"]
# }

variable "configs" {
  type = list(object({
    subnet_name   = string
    name          = string
    region        = string
    zone          = string
    cidr_range    = string
  }))
  default = [ 
    {
    subnet_name = "tlnt-subnet-us-east1"
    name = "tlnt-vm-1"
    region = "us-east1"
    zone = "us-east1-b"
    cidr_range = "172.0.0.0/24"
  },
    {
    subnet_name = "tlnt-subnet-us-central1"
    name = "tlnt-vm-2"
    region = "us-central1"
    zone = "us-central1-a"
    cidr_range = "172.1.0.0/24"
  }
   ]
}

variable "name" {
  type = string
  default = "tlnt"
}
