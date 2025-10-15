variable "name" {
    type = string
    default = "tlnt"
}

variable "region" {
    type = list
    default = ["us-central1", "us-east1"]
}

variable "machine_type" {
    type = string
    default = "e2-micro"
}

variable "bastion_user" {
    type = string
    default = "talant_py"
}