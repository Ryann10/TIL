Dump databases
----------

[https://docs.mongodb.com/manual/tutorial/backup-and-restore-tools/](https://docs.mongodb.com/manual/tutorial/backup-and-restore-tools/)
```bash
#add authentication parameters if required
mongodump --host <HOST_ADDRESS> -u <ADMIN_NAME> -p <ADMIN_PASSWORD> --authenticationDatabase admin
```
