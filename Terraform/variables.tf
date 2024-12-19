variable "access_key" {
    type = string
    sensitive = true
  
}
variable "secret_key" {
    type=string
    sensitive = true
  
}
variable "region" {}

variable "instance_type" {
    default = "t3.micro"
  
}
variable "vpc_id" {
  type = string
}

