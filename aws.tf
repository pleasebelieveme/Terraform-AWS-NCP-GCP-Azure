# AWS 서비스 및 지역 설정 (서울 지역)
provider "aws" {
    region = "ap-northeast-2"
}

# VPC 리소스 생성
resource "aws_vpc" "my_vpc" {
    # VPC의 IP 주소 범위 설정
    cidr_block = "172.16.0.0/16" 
    # VPC에 이름 설정
    tags = {
        Name = "myVPC" 
    }
}

# Subnet 리소스 생성
resource "aws_subnet" "my_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    # Subnet의 IP 주소 범위 설정
    cidr_block        = "172.16.10.0/24" 
    # 사용할 가용 영역 설정
    availability_zone = "ap-northeast-2a" 
    # Subnet에 이름 설정
    tags = {
        Name = "mySubnet" 
    }
}

# Network Interface 리소스 생성
resource "aws_network_interface" "my_net" {
    subnet_id   = aws_subnet.my_subnet.id
    # Network Interface에 할당할 IP 주소 설정
    private_ips = ["172.16.10.100"] 
    # Network Interface에 이름 설정
    tags = {
        Name = "private_network_interface" 
    }
}

# Ubuntu Instance 생성
resource "aws_instance" "ubuntu" {
    # Ubuntu 20.04 AMI ID
    ami           = "ami-0225bc2990c54ce9a" 
    # 인스턴스 유형 설정
    instance_type = "t2.micro" 

    network_interface {
        network_interface_id = aws_network_interface.my_net.id
        device_index         = 0
    }
    # 인스턴스에 이름 설정
    tags = {
        Name = "myUbuntu" 
    }
}
