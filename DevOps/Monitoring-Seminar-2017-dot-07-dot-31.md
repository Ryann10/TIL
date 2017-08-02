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


클라우드 환경에서의 모니터링
========

클라우드 환경에서 수집해야하는 지표
----
- IOPS
- Disk Queue length(win) / iowait(linux)
- CPU steal time

일반적인 서버 다운 인지 방법
-----
- 서버에서 데이터가 들어오지 않을때
- But, 서버 가용성과 네트워크 가용성은 별도로 모니터링 해야함

**Utilization Saturation Error 3가지 지표를 만들어서 봐야함**

프로세스 모니터링
-----
- 그룹별로 모니터링 
- 그룹 정책 수립(최소&최대 수, CPU 사용량 등)
- TCP connection 상태 모니터링
- CLOSE_WAIT 값 확인 필요

모니터링 시스템 구축 시 유의사항
------
- 데이터베이스는 타임 시리즈 디비 > RDB
- 데이터 전송 방식은 20초 이내 짧은 조기로 stream으로 조금씩, 1분 마다 모아서 보내면 cpu 사용률이 1분씩마다 튄다
- 모니터링 부하를 적게 주기 위해 Golang 을 agent 언어로 많이 사용함
- 시스템의 완결성을 보장(클라우드 가용성 보장)을 위해 업체(AWS, Azure, GoogleAppEngine) 을 같이 쓰는 방법도 있다
