variable "region" {
  description = "The region where the resources will be created"
  default     = "ap-seoul"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "ap-seoul-1"
}

variable "mysql_root_password" {
  description = "The root password for the MySQL instance"
  default     = "AdminAdmin123"
  sensitive   = true
}
