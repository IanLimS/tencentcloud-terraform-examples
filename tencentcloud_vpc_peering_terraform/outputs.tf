output "vpc1_id" {
  value = tencentcloud_vpc.vpc1.id
}

output "vpc2_id" {
  value = tencentcloud_vpc.vpc2.id
}

output "cvm1_private_ip" {
  value = tencentcloud_instance.cvm1.private_ip
}

output "cvm2_private_ip" {
  value = tencentcloud_instance.cvm2.private_ip
}