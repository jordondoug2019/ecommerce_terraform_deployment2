variable "instance_type" {
    default = "t3.micro"
  
}
variable "region" {
  default = "us-east-1"
  description = "AWS Region"
}
variable "vpc_id"{
  description = "value"
}
variable "public_subnet" {
  type=list(string)
  description = "value"
}
variable "private_subnet" {
  type = list(string)
  description = "value"
}
# List of Availability Zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "FrontEnd_SecurityGroup_id" {
  description = "value"
  
}
variable "Backend_SecurityGroup_id" {
  description = "value"
  
}
variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "ecommercedb"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "kurac5user"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  default     = "kurac5password"
}
variable "peer_owner_id" {
  default = "value"
}
variable "ec2_instance_ids" {
  type = list(string)  # Change to list if returning multiple IDs
}

