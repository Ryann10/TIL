서비스 단계에 따른 모니터링 전략
===============
1. 시작단계 - 서버 1대 (Web server + DBMS)

- top, tail 명령어를 이용하여 모니터링

2. 서버 2대 (Web Server 1대 + DBMS 1대)

- watch 명령어를 이용하여 모니터링 (ex., watch -d -n 5 W)

3. 서버 3~7대 (Web Server 5대 + DBMS 2대)

- DAU 1만명, Series A 펀딩 시기 쯤
- LogStash, fluentd 와 같은 로그 수집기를 이용한 중앙 관리 시스템 구축
- 구조: l4 -> Web Server -> DBMS
- 경험 상, Web Server 5대 + DBMS 1대의 구조가 운영하기 좋았다.

4. 서버 8~20대 (Web Server 16대 + DBMS 4대)

- Nagios, Zabbix, Icinga 와 같은 APM 툴 이용


시스템이 뻗는 순서 (대응 해야 하는 순서)
---------
DBMS > WEB SERVER > IO(Hard disk) > NETWORK > CODE(Business Logic)

전문 모니터링 툴 팁
--------
**문제점** : 모니터링 Agent cpu 1~15% 사용함에 따라, 기존 서비스가 감당할 수 있던 Capacity를 감당하지 못하게 됨.

**해결책** : 표본 서버(Web Server 1대 + DBMS 1대)만 선택하여 모니터링

