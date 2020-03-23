### 공용 계정 비밀번호

  - 3개월마다 주기적으로 변경
  - 계정을 추가 할 수 있는 서비스의 경우엔, **마스터** 계정과 **일반** 계정으로 분리
    - 마스터 계정은 팀장만 권한 부여
  - 퇴사자가 접근할 수 있는 계정 중 마스터 권한이 있다거나, 결제가 가능한 계정의 경우 비밀번호 변경
  - 가이드라인 확인 https://www.owasp.org/index.php/Authentication_Cheat_Sheet
  - 어드민 권한이 필요할 경우, 임시로 권한을 부여하는 프로세스 만들기
  - 공용 계정 디비 분리

### SEP 업데이트

- 주기적인 업데이트 확인
- 설정 확인
  - USB, 블루투스, 모바일 장비 연결 막기 https://support.symantec.com/en_US/article.TECH175220.html
  - EDR

### 추가 도메인 구입

- 첫번째 도메인은 아웃바운드용 도메인. 홈페이지나 공식적인 용도로 사용. 이메일 도메인은 이메일 보안 강화 작업을 추가로 진행
  - DKIM으로 이메일 인증
  - SPF로 발신자 권한 부여
  - DMARC를 사용하여 발신 스팸 방지
  - https://support.google.com/a/topic/7556597?hl=ko&ref_topic=7556782
- 두번째 도메인은 rest api endpoint 와 같은 개발을 위한 용도로 사용
- 세번째 도메인은 백오피스와 같은 내부 용도로 사용

### SSL/TLS/HTTPS 사용

- 사용하지 않고 있는 서비스 확인 후 적용

### 퇴사자에 의한 정보 탈취 위협

- 체크 리스트를 만들어 중지 및 삭제 할 서비스 계정들 확인
- 구글 독스 로그를 활용하여 퇴사자가 문서를 다운로드 했는지 확인
- 전 회사에 레퍼런스 체크를 통해 퇴사 사유가 문제를 발생 시켜서는 아닌지 여부 확인

### VPN 구축

- 2FA

### 물리적인 보안

- 화면 보호기 (최대 5분) + 비밀번호 로그인 설정
- 외부 사람이 피씨에 접근 할 수 없도록 하기
- 서버 실 잠금장치 설치
  - 서버를 누군가 고의적으로 고장냈을 때 대비가능한 방법 고려
- 개인 피씨 백업
- 랩탑
  - 게스트 계정으로만 이용하여, 사용한 파일을 권한외의 다른 팀원이 확인 할 수 없도록 설정

### 개인 피씨 보안
- Active Directory

### 클라우드 서버 보안

- 디도스 공격 대비
- 참고: https://blog.cloudflare.com/how-to-drop-10-million-packets-ko/
- security@xxx.xx 계정 추가 후 웹사이트에 표시
> 보안 취약점/사고와 관련된 메일 수신. Security researches may prefer sending an encrypted email, so you should generate an OpenPGP key pair, publish your public key on the website and save the private key in your password manager.
- 개발 네트워크와 프로덕션 네트워크 분리 like VPC (for AWS)
- WAF and DDoS mitigation service
- 허로쿠
  - SSH 또는 CLI 통한 접근 권한 정리. inbound 설정이 가능한지 확인
  - 배포 => 자동화
  - 환경 설정 관리는 ARE 팀에서 관리하는 계정 통해서 진행
- inbound(whitelist) 설정

### SW 보안인증

- 글로벌 보안인증 ISO 27001
- 클라우드 기반상 개인정보 취급 관련 인증 ISO 27018 인증

### 스마트폼

- 인증 시스템
  - JWT
  - 2FA

### 구글 독스

- 쉽게 관리할 수 있는 방법 있는지 확인

### 개발

- 소스코드 취약점 분석
  - Monitoring your dependencies for known vulnerabilities (and license issues) with services like Snyk, SourceClear, BlackDuck.
  - Static and dynamic code analysis of your code (CheckMarx, Veracode)
- Use Penetration Tests and Bug Bounty Programs. This is where you pay a real hacker to try and find specific vulnerabilities. During this test you are allowing an external PT vendor to try and circumvent your security and take advantage of vulnerabilities and misconfiguration.
  - In some cases you would provide the Pen-Tester API keys to simulate a situation that one of your customers got hacked, and the hacker propagates into your organisation using their secret api keys. This is called grey PT.
  - In other cases you would also allow the PT to review your codebase. The price depends on the complexity of the service, the hacker experience and the lines-of-codes.

### 데이터 백업

- 백업은 자동화되어있고, 지속적이어야 하고 필요한 데이터셋을 전부 커버
- 데이터 백업은 다른 클라우드 계정을 통해 관리
> 사람의 실수나 악의적인 삭제를 방지하기 위해
- 데이터 백업은 다른 지역의 다른 데이터 센터에
> 자연적인 재해에 의한 문제 발생도 고민할 필요가 있음
- 데이터 복구 과정 문서화 및 테스트가 잘 되어 있어야 한다

### 사고 대비

- 모든 서비스의 로그 집중화
- 로그는 최소 1년은 수집

### 종이 서류는?

### Miscellaneous

- 2FA 사용
> Google accounts, Dropbox, Github, Microsoft, etc.
- 2FA 제공
  - 문자/전화를 통한 2FA 방식은 보안에 취약함으로 지양
- https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project 연습
- Penetration Tests and Bug Bounty Programs
- 위키
  - 백업 강화
  - 계정 권한 세분화
  - 파일 다운로드 금지

### Referred

- https://github.com/forter/security-101-for-saas-startups/blob/english/security.md