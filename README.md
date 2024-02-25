하이브리드 클라우드 아키텍처 개요
프로젝트 명칭 : 하이브리드 클라우드

개요
본 프로젝트는 AWS와 오픈스택을 활용한 하이브리드 클라우드 아키텍처를 구축하고 운영한 경험을 기술
주요 목적은 클라우드의 확장성과 온프레미스 시스템의 보안성을 결합하여, 비즈니스 요구 사항에 부합하는 유연하고 견고한 인프라를 제공 
AWS를 메인 서비스로 활용하면서 오픈스택은 주로 데이터베이스 백업 용도로 운영 중

프로젝트 아키텍처
![image](https://github.com/hyoungdong-choi/app-git/assets/154504078/a45afb02-9980-41a2-9cf3-36547f5b7109)

온프레미스 환경
＊ VMware
＊ OpenStack


AWS 환경
핵심 서비스
＊ Amazon Route 53: 도메인 이름 시스템(DNS) 서비스
＊ Amazon S3: 객체 스토리지 서비스
＊ AWS Lambda: 이벤트 기반 서버리스 컴퓨팅 서비스
＊ Amazon DynamoDB: NoSQL 데이터베이스 서비스
＊ Amazon API Gateway: API 관리
＊ Amazon RDS: 관계형 데이터베이스 서비스
＊ Amazon CloudWatch: 모니터링 및 관리 서비스

보안 및 컴플라이언스
＊ AWS WAF: 웹 애플리케이션 방화벽
＊ AWS Shield: DDoS 보호
＊ GuardDuty: 위협 탐지 서비스
＊ Macie: 데이터 보안 및 개인 정보 보호 서비스
＊ AWS Inspector: 애플리케이션 보안
＊ Security Hub: 통합 보안 관리 서비스

데이터 처리 및 분석
＊ AWS Glue: ETL 서비스
＊ Amazon Athena: SQL 쿼리 서비스
＊ Amazon QuickSight: 비즈니스 인텔리전스 서비스
＊ Amazon Elasticsearch Service: 검색 및 로그 분석




<img src="https://github.com/hyoungdong-choi/app-git/assets/154504078/f8639809-2704-477d-819b-c052ae5c0f22">

