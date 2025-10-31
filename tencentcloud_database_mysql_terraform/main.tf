provider "tencentcloud" {
  region = "ap-seoul"
}

resource "tencentcloud_vpc" "vpc" {
  name       = "ianlim_db_vpc"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_subnet" "subnet" {
  name              = "ianlim_db_subnet"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-seoul-1"
}


resource "tencentcloud_security_group" "sg" {
  name = "ianlim_db_sg"
}

resource "tencentcloud_security_group_lite_rule" "sg" {
  security_group_id = tencentcloud_security_group.sg.id

  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#3306#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#3306#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]
}


resource "tencentcloud_mysql_instance" "mysql" {
  instance_name      = "ianlim_db_mysql-instance"
  mem_size           = 8000
  volume_size        = 100
  engine_version     = "8.0"
  root_password      = "AdminAdmin123"
  availability_zone  = "ap-seoul-1"
  vpc_id             = tencentcloud_vpc.vpc.id
  subnet_id          = tencentcloud_subnet.subnet.id
  security_groups    = [tencentcloud_security_group.sg.id]
  internet_service   = 1
}

resource "tencentcloud_instance" "jump_server" {
  instance_name       = "ianlim_db_jump_server"
  instance_type       = "SA5.MEDIUM4"
  image_id            = "img-9qabwvbn"
  vpc_id              = tencentcloud_vpc.vpc.id
  subnet_id           = tencentcloud_subnet.subnet.id
  availability_zone          = var.availability_zone
  security_groups     = [tencentcloud_security_group.sg.id]
  allocate_public_ip  = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mysql
              systemctl enable sshd
              systemctl start sshd
              EOF
}
