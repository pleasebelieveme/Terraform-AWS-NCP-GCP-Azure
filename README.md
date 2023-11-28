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
