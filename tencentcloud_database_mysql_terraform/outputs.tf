output "vpc_id" {
  description = "The ID of the VPC"
  value       = tencentcloud_vpc.vpc.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = tencentcloud_subnet.subnet.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = tencentcloud_security_group.sg.id
}

output "mysql_instance_id" {
  description = "The ID of the MySQL instance"
  value       = tencentcloud_mysql_instance.mysql.id
}

output "mysql_endpoint" {
  description = "The endpoint of the MySQL instance"
  value       = tencentcloud_mysql_instance.mysql.internet_host
}

output "mysql_port" {
  description = "The port of the MySQL instance"
  value       = tencentcloud_mysql_instance.mysql.internet_port
}


