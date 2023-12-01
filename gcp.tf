# Google Cloud Platform에 액세스하는 Provider 설정
provider "google" {
  # GCP 서비스 계정 키 파일의 경로
  credentials = file("earnest-fuze-405810-cbd37f7bb561.json")
  
  # GCP 프로젝트 ID
  project     = "earnest-fuze-405810"
  
  # 한국 지역 설정 (asia-northeast3은 서울 지역)
  region      = "asia-northeast3"
  
  # 가상 머신이 속할 지역 및 존 설정
  zone        = "asia-northeast3-a"
}

# GCP에서 사용할 네트워크 리소스 설정
resource "google_compute_network" "vpc_network" {
  # 네트워크 이름 설정
  name = "terraform-network"
}

# GCP에서 가상 머신을 생성하는 리소스 설정
resource "google_compute_instance" "vm_instance" {
  # 가상 머신의 이름
  name         = "terraform-instance"
  
  # 가상 머신의 크기 및 성능 설정
  machine_type = "f1-micro"

  # 가상 머신의 부팅 디스크 설정
  boot_disk {
    initialize_params {
      # Ubuntu 22.04 이미지를 사용하여 부팅 디스크 초기화
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # 가상 머신이 속할 네트워크 설정
  network_interface {
    # 사용할 네트워크의 이름 설정
    network = google_compute_network.vpc_network.name
    
    access_config {
      # 별도의 설정이 필요 없다면 비워둘 수 있습니다.
    }
  }
}
