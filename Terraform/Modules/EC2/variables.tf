variable "instance_type" {
    default = "t3.micro"
  
}
variable "vpc_id"{
  description = "value"
}
variable "public_subnet" {
  type= list(string)
  description = "value"
}
variable "private_subnet" {
  type= list(string)
  description = "value"
}
variable "FrontEnd_SecurityGroup_id" {
  description = "value"
  
}
variable "Backend_SecurityGroup_id" {
  description = "value"
  
}


