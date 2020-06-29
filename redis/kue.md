# [kue](https://github.com/Automattic/kue)

Features
----------
- Delayed jobs
- Distribution of parallel work load
- Job event and progress pubsub
- Job TTL
- Optional retries with backoff
- Graceful workers shutdown
- Full-text search capabilities
- Job specific logging

kue-UI application Features
----------
- RESTful JSON API
- Rich integrated UI
- UI progress indication

Document 정리 (v0.11.6 기준)
---------
- 기본적으로 job fetch를 한번만 실행 (실패 시 직접 처리해주기 전까지 남아있음)
- Progress 로깅이 가능함 (현재 상태에 따른 추가적인 데이터를 전달 가능) => UI app에서 확인 가능
- nodejs 프로세스 재 시작시 특정 job object 에 대한 이벤트들을 받을 수 있을지 보장하지 않음
- Connection 은 기본적으로 단일 노드에 대해서만 통신을 지원해주는 인터페이스만 존재
- Cluster나 Sentinel을 사용할 경우, Redis client module 을 [ioredis](https://github.com/luin/ioredis) 로 교체하여 사용하는 방법을 가이드