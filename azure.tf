# 테라폼 초기 설정
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

# Azure Provider 설정
provider "azurerm" {
  features {} # 특별한 기능 활성화 없음
}

# 리소스 그룹 생성 (없다면)
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "myResourceGroup"  # 리소스 그룹 이름
  location = "koreacentral"      # Azure 지역

  tags = {
    environment = "Terraform Demo"  # 환경 식별용 태그
  }
}

# 가상 네트워크 생성
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"                        # 가상 네트워크 이름
  address_space       = ["10.0.0.0/16"]                 # 주소 공간
  location            = "koreacentral"                  # Azure 지역
  resource_group_name = azurerm_resource_group.myterraformgroup.name  # 리소스 그룹 참조

  tags = {
    environment = "Terraform Demo"  # 환경 식별용 태그
  }
}

# 서브넷 생성
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"                      # 서브넷 이름
  resource_group_name  = azurerm_resource_group.myterraformgroup.name  # 리소스 그룹 참조
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name  # 가상 네트워크 참조
  address_prefixes     = ["10.0.0.0/24"]                 # 주소 공간
}

# 공용 IP 생성
resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "myPublicIP"                # 공용 IP 이름
  location                     = "koreacentral"              # Azure 지역
  resource_group_name          = azurerm_resource_group.myterraformgroup.name  # 리소스 그룹 참조
  allocation_method            = "Dynamic"                   # 동적 IP 할당

  tags = {
    environment = "Terraform Demo"  # 환경 식별용 태그
  }
}

# 출력: 가상 머신의 공용 IP 주소
output "vm_public_ip" {
  value = azurerm_public_ip.myterraformpublicip.ip_address  # 공용 IP 주소 출력
}

# 네트워크 보안 그룹 및 규칙 생성
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"        # NSG 이름
  location            = "koreacentral"                  # Azure 지역
  resource_group_name = azurerm_resource_group.myterraformgroup.name  # 리소스 그룹 참조

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"  # 환경 식별용 태그
  }
}

# 네트워크 인터페이스 생성
resource "azurerm_network_interface" "myterraformnic" {
  name                      = "myNIC"                       # NIC 이름
  location                  = "koreacentral"                # Azure 지역
  resource_group_name       = azurerm_resource_group.myterraformgroup.name  # 리소스 그룹 참조

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id  # 서브넷 참조
    private_ip_address_allocation = "Dynamic"                   # 동적 사설 IP 할당
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id  # 공용 IP 참조
  }

  tags = {
    environment = "Terraform Demo"  # 환경 식별용 태그
  }
}

# 네트워크 인터페이스에 보안 그룹 연결
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id  # NIC 참조
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id  # NSG 참조
}

# 고유한 스토리지 계정 이름을 위한 무작위 텍스트 생성
resource "random_id" "randomId" {
  keepers = {
    # 새로운 리소스 그룹이 정의될 때만 새 ID 생성
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

# 부팅 진단을 위한 스토리지 계정 생성
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"  # 고유한 스토리지 계정 이름
  resource_group_name
