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
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "ALL"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "22011"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "22003"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "icmp"
    policy      = "accept"
  }
  name        = "ianlim-peering-sg1"
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

resource "tencentcloud_security_group_rule" "sg1_cos_migration_port1" {
  security_group_id = tencentcloud_security_group.sg1.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22011"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg1_cos_migration_port2" {
  security_group_id = tencentcloud_security_group.sg1.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22003"
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
    ip_protocol = "tcp"
    port_range  = "22011"
    policy      = "accept"
  }
  egress {
    cidr_ip     = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range  = "22003"
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

resource "tencentcloud_security_group_rule" "sg2_cos_migration_port2" {
  security_group_id = tencentcloud_security_group.sg2.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22011"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "sg2_cos_migration_port2" {
  security_group_id = tencentcloud_security_group.sg2.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "TCP"
  port_range        = "22003"
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
  instance_name              = "ianlim-peering-cvm1"
  image_id                   = var.image_id
  instance_type              = var.instance_type
  subnet_id                  = tencentcloud_subnet.subnet1.id
}

##################
# COS Buckets
##################
resource "tencentcloud_cos_bucket" "cos1" {
  bucket = "ianlim-peering-cos1"
  acl    = "private"
  region = "ap-seoul"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_cos_bucket" "cos2" {
  bucket = "ianlim-peering-cos2"
  acl    = "private"
  region = "ap-seoul"
  tags = {
    SA = "ianlim"
  }
}

##################
# VPC Endpoints
##################
resource "tencentcloud_vpc_endpoint" "endpoint1" {
  vpc_id          = tencentcloud_vpc.vpc1.id
  service_id      = "vpcsvc-ocuykgps"
  peer_account    = "2832742109"
  peer_account_type = "other tencent account"
  tags = {
    SA = "ianlim"
  }
}

resource "tencentcloud_vpc_endpoint" "endpoint2" {
  vpc_id          = tencentcloud_vpc.vpc2.id
  service_id      = "vpcsvc-ocuykgps"
  peer_account    = "2832742109"
  peer_account_type = "other tencent account"
  tags = {
    SA = "ianlim"
  }
}