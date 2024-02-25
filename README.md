**프로젝트 개요**\
프로젝트 명칭 : 하이브리드 클라우드 아키텍처 구축

목적: 
- 클라우드의 확장성과 온프레미스 시스템의 보안성을 결합하여 유연하고 견고한 인프라 제공
- 비즈니스 요구사항에 맞는 탄력적인 컴퓨팅 및 스토리지 환경 구축
- 운영 효율성 증대 및 비용 절감

프로젝트 아키텍처
![image](https://github.com/hyoungdong-choi/app-git/assets/154504078/a45afb02-9980-41a2-9cf3-36547f5b7109)

주요 기술:
- AWS
- OpenStack
- VMware

프로젝트 기간: 2024.01.15 ~ 2024.01.30

**시스템 아키텍처**\
연결성
＊ Site to Site VPN: 온프레미스 환경과 클라우드 환경 연결

온프레미스 환경
＊ VMware 기반 가상화 환경
＊ OpenStack 클라우드 플랫폼

AWS 환경
 - 핵심 서비스\
  ＊ Amazon Route 53: 도메인 이름 시스템(DNS) 서비스\
  ＊ Amazon S3: 객체 스토리지 서비스로 대용량 데이터 저장\
  ＊ AWS Lambda: 이벤트 기반 서버리스 컴퓨팅으로 자동화 및 비용 절감\
  ＊ Amazon DynamoDB: NoSQL 데이터베이스 서비스\
  ＊ Amazon API Gateway: API 관리\
  ＊ Amazon RDS: 관계형 데이터베이스 서비스\
  ＊ Amazon CloudWatch: 모니터링 및 관리 서비스\

 - 보안 및 컴플라이언스\
  ＊ AWS WAF: 웹 애플리케이션 방화벽으로 공격 차단\
  ＊ AWS Shield: DDoS 공격으로부터 보호\
  ＊ GuardDuty: 위협 탐지 서비스로 이상 활동 감지 및 알림\
  ＊ Macie: 데이터 보안 및 개인 정보 보호 서비스로 중요 데이터 보호\
  ＊ AWS Inspector: 데이터 보안 및 개인 정보 보호 서비스로 중요 데이터 보호\
  ＊ Security Hub: 통합 보안 관리 서비스로 보안 상태 종합적 관리\

 - 데이터 처리 및 분석\
  ＊ AWS Glue: ETL 서비스로 데이터 수집, 정제, 통합\
  ＊ Amazon Athena: SQL 쿼리 서비스로 간편한 데이터 분석\
  ＊ Amazon QuickSight: 비즈니스 인텔리전스 서비스로 데이터 시각화 및 분석\
  ＊ Amazon Elasticsearch Service: 검색 및 로그 분석 서비스로 실시간 데이터 분석\

기대효과
- 확장성 및 탄력성 확보
- 보안 강화 및 컴플라이언스 요구사항 충족
- 운영 효율성 증대 및 비용 절감
- 마이스로 서비스 구축을 통한 개발 및 운영 효율성 향상, 확장성 및 탄력성 강화, 고가용성 및 안정성 확보
- 람다를 사용한 서버리스 환경 구축을 통한 서버 관리 부담 해소, 자동화 및 탄력적인 확장, 비용 절감

향후 계획
- 지속적인 성능 및 보안 모니터링
- 사용자 요구에 따른 시스템 확장 및 기능 추가
- EKS로 컴퓨팅환경 구축

**인프라 프로비저닝 및 관리(Terraform 사용)**\
테라폼을 사용하여 AWS 클라우드 환경을 코드를 통해 구성하고 관리

테라폼 구현(일부 서비스)
![image](https://github.com/hyoungdong-choi/app-git/assets/154504078/1815ab5b-41b2-42fa-b4f4-b5bec2e3905b)
\
\
테라폼으로 구현하여 시현 영상\
<img src="https://github.com/hyoungdong-choi/app-git/assets/154504078/f8639809-2704-477d-819b-c052ae5c0f22">

