WIP..

Hashtag
-----
특정키들이 같은 노드안에 저장

Cluster Nodes
-----
- Auto-discover other nodes
- detect non-working nodes
- promote slave nodes to master

Redis Cluster Bus
-----
- TCP bus와 binary protocol에 의해 모든 노드들은 연결되어 있는데 이것을 **Redisd Cluster Bus**라고 부른다. 
- Every node is connected to every other node via cluster bus.
- gossip 프로토콜 사용 (새 노드 탐색, ping packet들을 보내며 모든 노드들이 제대로 동작하고 있는지 확인, 특정 조건을 알리는데 필요한 클러스터 메시지 전송)
- Since cluster nodes are not able to proxy requests, clients may be redirected to other nodes using redirection errors -MOVED and -ASK. The client is in theory free to send requests to all the nodes in the cluster, getting redirected if needed, so the client is not required to hold the state of the cluster. However clients that are able to cache the map between keys and nodes can improve the performance in a sensible way.


Performance
-----
- 커맨드를 주어진 키에 맞는 노드로 프록시 하지 않고, 클라이언트들을 해당 키를 서빙하는 노드로 리다이렉트 시킨다.


Key distribution model
-----
```
HASH_SLOT = CRC16(key) mod 16384
```

참고
--------
- [파티셔닝 관련 문서](https://redis.io/topics/partitioning)
- [클러스터 튜토리얼](https://redis.io/topics/cluster-tutorial)
- [클러스터 튜토리얼](https://redis.io/topics/cluster-spec)