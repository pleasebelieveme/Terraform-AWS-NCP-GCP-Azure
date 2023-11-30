# Terraform + AWS(EC2) + NCP(Server) + GCP(VM) + Azure(VM) Automation
Terrform을 이용해 AWS(EC2), NCP(Server), GCP(CE), Azure(VM)을 생성하는 방법을 구현해보았다.
                         
   
## 시스템 환경


- wsl2 - ubuntu 22.04
- Terraform v1.6.4
## 파일구성
```
Terraform-aws-ncp  
├─ aws.tf
├─ ncp.tf
├─ gcp.tf
├─ azure.tf
└─ README.md
```
## 준비물

 ### 1. AWS IAM key    

* #### key 적용 방법 <br>
```
aws configure
```
└─ 위의 명령어를 치면 아래의 항목을 입력하라고 나온다.
```
AWS Access Key ID []: <엑세스키>
AWS Secret Access Key []: <시크릿키>
Default region name []: <지역>
Default output format []: <저장파일의 형식>
```

한줄씩 입력하여 적용한다.



 ### 2. NCP API 인증키
 ```
 https://www.ncloud.com/mypage/manage/authkey
```
└─ 위 사이트로 들어가 로그인을 하고 신규 인증키를 생성한다.

```
provider "ncloud" {
  access_key    = "<엑세스키>"
  secret_key    = "<시크릿키>"
  region        = "KR"
  site          = "public"
  support_vpc   = "true"
}
```
└─ 생성된 신규 인증키를 위 부분에 적용시킨다.
 ### 3. GCP API 인증키
 - Compute Engine API 활성화

```
https://cloud.google.com
```
└─ 위의 사이트를 로그인하고 검색항목에서 'compute Engine API'를 검색한다.
새창이 열리면 API서비스활성화를 클릭하여 활성화시켜준다.</br>

- 프로젝트 ID 적용
홈화면에서 왼쪽 위 Google Cloud 오른편에 프로젝트 ID가 있다.</br>
클릭을 하고 프로젝트 이름이 아닌 '프로젝트 ID'를 아래의 항목에 입력해준다.</br>
```
provider "google" {
  credentials = file("<파일이름.확장자까지입력>")
  project     = "<프로젝트 ID>"    <-----
  region      = "asia-northeast3"
  zone        = "asia-northeast3-a"
}

```

- 어카운트키 적용</br>
검색창에서 'service accounts'항목을 클릭한다.</br>
서비스 계정 만들기 항목을 클릭한다.</br>
원하는 이름을 정하여 입력하여주고 만들고 계속하기를 클릭하여 준다.</br>
역할 선택을 클릭하고 기본(Basic)항목에서 편집자를 선택하여 준다.</br>
완료를 눌러 서비스 계정 만들기를 완료한다.</br>
서비스계정확인 페이지에서 오른쪽에 작업을 클릭하여 키관리 페이지로 들어간다.</br>
'키추가'항목을 누르고 'JSON'유형으로 '만들기'를 클릭하면 자동적으로 내 컴퓨터 다운로드에 어카운트키 파일이 저장된다.</br>
테라폼을 실행할 폴더에 어카운트키를 옮기고 아래의 항목에 입력해준다.</br>

```
provider "google" {
  credentials = file("<파일이름.확장자까지입력>")    <-----
  project     = "<프로젝트 ID>"
  region      = "asia-northeast3"
  zone        = "asia-northeast3-a"
}
```
### 4. Azure 로그인

## 실습적용
```
terraform init
```
└─ 위의 명령어를 치면 Terraform 설정을 초기화하고 적용한다.
```
terraform apply -auto-approve
```
└─ 위의 명령어를 치면 AWS(EC2), NCP(Server), GCP(CE), Azure(VM)를 생성한다.
```
terraform destroy -auto-approve
```
└─ 위의 명령어를 치면 AWS(EC2), NCP(Server), GCP(CE), Azure(VM)가 삭제된다.
