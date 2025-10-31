# database.tf

# 기존 VPC 데이터 참조
data "tencentcloud_vpc" "vpc" {
  name = "ianlim-priv-peering-vpc1"  # main.tf에서 생성한 VPC 이름으로 교체
}

# 기존 서브넷 데이터 참조
data "tencentcloud_subnet" "subnet" {
  name   = "ianlim-priv-peering-subnet1"  # main.tf에서 생성한 서브넷 이름으로 교체
  vpc_id = data.tencentcloud_vpc.vpc.id
}

# 기존 보안 그룹 데이터 참조
data "tencentcloud_security_group" "sg" {
  name = "ianlim-priv-peering-sg1"  # 기존 보안 그룹 이름으로 교체
}

# 보안 그룹 규칙 추가 (3306 포트 허용)
resource "tencentcloud_security_group_rule" "mysql_rule" {
  security_group_id = data.tencentcloud_security_group.sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "3306"
  policy            = "accept"
  description       = "Allow MySQL access"
}

# TencentDB for MySQL 인스턴스 생성
resource "tencentcloud_mysql_instance" "mysql" {
  instance_name     = "ianlim-mysql-instance-seoul"
  engine_version    = "8.0"
  root_password     = "AdminAdmin123"
  mem_size          = 8000  # 8GB
  cpu               = 4     # 4코어
  volume_size       = 100   # 100GB 스토리지
  availability_zone = "ap-seoul-1"
  vpc_id            = data.tencentcloud_vpc.vpc.id
  subnet_id         = data.tencentcloud_subnet.subnet.id
  security_groups   = [data.tencentcloud_security_group.sg.id]

  # InnoDB 엔진 설정
  parameters = {
    character_set_server = "utf8mb4"
    innodb_buffer_pool_size = "6G"
  }

  internet_service = 1  # 공용 네트워크 액세스 활성화

  tags = {
    SA = "ianlim"
  }
}

# Elastic IP 생성
resource "tencentcloud_eip" "mysql_eip" {
  name      = "ianlim-mysql-public-ip"
  bandwidth = 10  # 10Mbps
}

# EIP를 데이터베이스에 연결
resource "tencentcloud_eip_association" "eip_mysql" {
  eip_id      = tencentcloud_eip.mysql_eip.id
  instance_id = tencentcloud_mysql_instance.mysql.id
}

# 출력값 설정
output "mysql_endpoint" {
  value = tencentcloud_mysql_instance.mysql.internet_host
}

output "mysql_port" {
  value = tencentcloud_mysql_instance.mysql.internet_port
}

output "mysql_public_ip" {
  value = tencentcloud_eip.mysql_eip.public_ip
}
