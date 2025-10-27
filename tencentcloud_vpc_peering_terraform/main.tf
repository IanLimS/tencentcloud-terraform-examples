##################
# VPC 
##################
resource "tencentcloud_vpc" "vpc1" {
  name       = "ianlim-peering-vpc1"
  cidr_block = "10.10.0.0/16"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_subnet" "subnet1" {
  name              = "ianlim-peering-subnet1"
  cidr_block        = "10.10.1.0/24"
  availability_zone = var.zone
  vpc_id            = tencentcloud_vpc.vpc1.id
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_vpc" "vpc2" {
  name       = "ianlim-peering-vpc2"
  cidr_block = "10.20.0.0/16"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_subnet" "subnet2" {
  name              = "ianlim-peering-subnet2"
  cidr_block        = "10.20.1.0/24"
  availability_zone = var.zone
  vpc_id            = tencentcloud_vpc.vpc2.id
  tags = {
    SA = "ianlim"
  }
}

##################
# Security Group
##################

resource "tencentcloud_security_group" "sg1" {
  name = "ianlim-priv-peering-sg1"
}

resource "tencentcloud_security_group_lite_rule" "sg1" {
  security_group_id = tencentcloud_security_group.sg1.id

  ingress = [
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#22011#TCP",
    "ACCEPT#0.0.0.0/0#22003#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#22011#TCP",
    "ACCEPT#0.0.0.0/0#22003#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]
}

resource "tencentcloud_security_group" "sg2" {
  name = "ianlim-priv-peering-sg2"
}

resource "tencentcloud_security_group_lite_rule" "sg2" {
  security_group_id = tencentcloud_security_group.sg2.id

  ingress = [
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#22011#TCP",
    "ACCEPT#0.0.0.0/0#22003#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#22011#TCP",
    "ACCEPT#0.0.0.0/0#22003#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
  ]
}

##################
# CVM
##################
resource "tencentcloud_instance" "cvm1" {
  instance_name              = "ianlim-peering-cvm1"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  subnet_id                  = tencentcloud_subnet.subnet1.id
  availability_zone          = var.zone
  security_groups            = [tencentcloud_security_group.sg1.id]
}

resource "tencentcloud_instance" "cvm2" {
  instance_name              = "ianlim-peering-cvm2"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  subnet_id                  = tencentcloud_subnet.subnet1.id
  availability_zone          = var.zone
  security_groups            = [tencentcloud_security_group.sg2.id]
}

##################
# COS Buckets
##################
resource "tencentcloud_cos_bucket" "cos1" {
  bucket = "ianlim-peering-cos1-${var.app_id}"
  acl    = "private"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_cos_bucket" "cos2" {
  bucket = "ianlim-peering-cos2-${var.app_id}"
  acl    = "private"
  tags = {
    SA = "ianlim"
  }
}
