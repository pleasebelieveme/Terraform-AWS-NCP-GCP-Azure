# 테라폼 설정 시작
terraform {
  # 사용할 플러그인 지정
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  # 테라폼 버전 지정
  required_version = ">= 0.13"
}

# 네이버 클라우드 플랫폼 제공자 설정
provider "ncloud" {
  # 접근 키 설정
  access_key    = "<엑세스키>"
  # 비밀 키 설정
  secret_key    = "<시크릿키>"
  # 지역 설정 (한국)
  region        = "KR"
  # 사이트 설정 (공용)
  site          = "public"
  # VPC 지원 설정
  support_vpc   = "true"
}

# 네이버 클라우드 플랫폼 VPC 리소스 설정
resource "ncloud_vpc" "vpc" {
  # CIDR 블록 설정
  ipv4_cidr_block = "172.16.0.0/16"
  # 이름 설정
  name            = "test-vpc"
}

# 네이버 클라우드 플랫폼 서버 리소스 설정
resource "ncloud_server" "public-server" {
  # 할당할 서브넷 식별자 설정
  subnet_no                 = ncloud_subnet.public-subnet.id
  # 서버 이름 설정
  name                      = "test-web01"
  # 서버 이미지 제품 코드 설정
  server_image_product_code = "SW.VSVR.OS.LNX64.CNTOS.0708.B050"
  # 서버 제품 코드 설정
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.HDD.B050.G002"
  # 로그인 키 설정
  login_key_name            = ncloud_login_key.loginkey.key_name
  # 네트워크 인터페이스 설정
  network_interface {
    # 할당된 네트워크 인터페이스 식별자 설정
    network_interface_no = ncloud_network_interface.public-server-nic.id
    # 순서 설정
    order                = 0
  }
}

# 네이버 클라우드 플랫폼 서브넷 리소스 설정
resource "ncloud_subnet" "public-subnet" {
  # 속한 VPC 식별자 설정
  vpc_no         = ncloud_vpc.vpc.id
  # 서브넷 CIDR 설정
  subnet         = "172.16.10.0/24"
  # 지역 설정
  zone           = "KR-2"
  # 네트워크 ACL 식별자 설정
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  # 서브넷 유형 설정 (PUBLIC)
  subnet_type    = "PUBLIC"
  # 서브넷 이름 설정
  name           = "public-a-subnet"
  # 사용 유형 설정 (일반)
  usage_type     = "GEN"
}

# 네이버 클라우드 플랫폼 로그인 키 리소스 설정
resource "ncloud_login_key" "loginkey" {
  # 로그인 키 이름 설정
  key_name = "test-key"
}

# 네이버 클라우드 플랫폼 네트워크 인터페이스 리소스 설정
resource "ncloud_network_interface" "public-server-nic" {
  # 할당할 서브넷 식별자 설정
  subnet_no             = ncloud_subnet.public-subnet.id
  # 이름 설정
  name                  = "test-web01-nic"
  # 접근 제어 그룹 설정
  access_control_groups = [ncloud_access_control_group.test-acg.access_control_group_no]
}

# 네이버 클라우드 플랫폼 접근 제어 그룹 리소스 설정
resource "ncloud_access_control_group" "test-acg" {
  # 이름 설정
  name        = "test-acg"
  # 속한 VPC 식별자 설정
  vpc_no      = ncloud_vpc.vpc.id
}
