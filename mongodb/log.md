### How to log all queries

[https://docs.mongodb.com/manual/reference/method/db.setProfilingLevel](https://docs.mongodb.com/manual/reference/method/db.setProfilingLevel)

```bash
ubuntu@ip-172-31-14-138:~$ mongo -u USER_NAME -p USER_PASSWORD --authenticationDatabase "admin"
MongoDB shell version: 3.0.12
connecting to: test
> use operation
switched to db operation
> db.getProfilingLevel()
0
> db.setProfilingLevel(1)
{ "was" : 0, "slowms" : 100, "ok" : 1 }
> db.getProfilingLevel()
1
```