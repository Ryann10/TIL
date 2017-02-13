# How to apply aws profile on jenkins

```bash
# move to jenkins home folder
$ cd /var/lib/jenkins

# make aws directory
$ sudo mkdir .aws

# put aws keys to profile file
$ sudo vi .aws/credentials
```

### ~/.aws/credentials
```bash
[default]
aws_access_key_id=AWS_ACCESS_KEY
aws_secret_access_key=AWS_SECRET_ACCESS_KEY
```
