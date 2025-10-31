provider "tencentcloud" {
  region = "ap-seoul"
}

resource "tencentcloud_vpc" "vpc" {
  name       = "vpc"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_subnet" "subnet" {
  name              = "subnet"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-seoul-1"
}

resource "tencentcloud_security_group" "sg" {
  name        = "sg"
  description = "Allow SSH, HTTP, HTTPS, and MySQL"
  vpc_id      = tencentcloud_vpc.vpc.id
}

resource "tencentcloud_security_group_rule" "ssh" {
  security_group_id = tencentcloud_security_group.sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "http" {
  security_group_id = tencentcloud_security_group.sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "80"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "https" {
  security_group_id = tencentcloud_security_group.sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "443"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "mysql" {
  security_group_id = tencentcloud_security_group.sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "3306"
  policy            = "accept"
}

resource "tencentcloud_mysql_instance" "mysql" {
  instance_name      = "mysql-instance"
  mem_size           = 8000
  volume_size        = 100
  engine_version     = "8.0"
  root_password      = "AdminAdmin123"
  availability_zone  = "ap-seoul-1"
  vpc_id             = tencentcloud_vpc.vpc.id
  subnet_id          = tencentcloud_subnet.subnet.id
  security_groups    = [tencentcloud_security_group.sg.id]
  internet_service   = 1
  internet_host      = ""
  internet_port      = 3306
}

resource "tencentcloud_instance" "cvm" {
  instance_name      = "cvm-instance"
  availability_zone  = "ap-seoul-1"
  image_id           = "img-pi0ii46r"
  instance_type      = "S5.MEDIUM4"
  system_disk_type   = "CLOUD_PREMIUM"
  system_disk_size   = 50
  vpc_id             = tencentcloud_vpc.vpc.id
  subnet_id          = tencentcloud_subnet.subnet.id
  security_groups    = [tencentcloud_security_group.sg.id]
  internet_max_bandwidth_out = 10
  allocate_public_ip = true
}
