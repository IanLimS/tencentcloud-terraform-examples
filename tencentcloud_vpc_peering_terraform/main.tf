##################
# VPC 
##################
resource "tencentcloud_vpc" "vpc1" {
  name       = "ianlim-priv-peering-vpc1"
  cidr_block = "10.10.0.0/16"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_subnet" "subnet1" {
  name              = "ianlim-priv-peering-subnet1"
  cidr_block        = "10.10.1.0/24"
  availability_zone = var.zone
  vpc_id            = tencentcloud_vpc.vpc1.id
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_vpc" "vpc2" {
  name       = "ianlim-priv-peering-vpc2"
  cidr_block = "10.20.0.0/16"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_subnet" "subnet2" {
  name              = "ianlim-priv-peering-subnet2"
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
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "ALL"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "icmp"
    policy      = "accept"
  }
  name        = "ianlim-priv-peering-sg1"
  description = "Allow SSH, HTTPS, ICMP"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_security_group_rule" "sg1_ssh" {
  security_group_id = tencentcloud_security_group.sg1.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg1_https" {
  security_group_id = tencentcloud_security_group.sg1.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "443"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg1_icmp" {
  security_group_id = tencentcloud_security_group.sg1.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "ICMP"
  policy            = "accept"
}

resource "tencentcloud_security_group" "sg2" {
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "ALL"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "icmp"
    policy      = "accept"
  }
  name        = "ianlim-priv-peering-sg2"
  description = "Allow SSH, HTTPS, ICMP"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_security_group_rule" "sg2_ssh" {
  security_group_id = tencentcloud_security_group.sg2.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg2_https" {
  security_group_id = tencentcloud_security_group.sg2.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "443"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg2_icmp" {
  security_group_id = tencentcloud_security_group.sg2.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "ICMP"
  policy            = "accept"
}

##################
# CVM
##################
resource "tencentcloud_instance" "cvm1" {
  instance_name              = "ianlim-priv-peering-cvm1"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  subnet_id                  = tencentcloud_subnet.subnet1.id
  availability_zone          = var.zone
  internet_max_bandwidth_out = 0
  orderly_security_groups    = [tencentcloud_security_group.sg1.id]
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_instance" "cvm2" {
  instance_name              = "ianlim-priv-peering-cvm2"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  subnet_id                  = tencentcloud_subnet.subnet2.id
  availability_zone          = var.zone
  internet_max_bandwidth_out = 0
  orderly_security_groups    = [tencentcloud_security_group.sg2.id]
  tags = {
    SA = "ianlim"
  }
}

##################
# VPC Peering
##################

resource "tencentcloud_vpc_peer_connect_manager" "peering_connection" {
  source_vpc_id         = tencentcloud_vpc.vpc1.id
  destination_vpc_id    = tencentcloud_vpc.vpc2.id
  destination_region    = var.region
  destination_uin       = var.uin
  peering_connection_name = "ianlim-priv-peering-peering-connection"
  # Optional: Set bandwidth, charge type, etc.
  # bandwidth = 100
}