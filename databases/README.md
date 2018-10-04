# DB Migration

## MySQL - Run

```
$ docker-compose up -d db
$ docker-compose logs -f
```

## MySQL - Create database

```
$ mysql -h127.0.0.1 -uroot -pmysql < tracker/create_databases.sql
```

### Check

```
$ mysql -h127.0.0.1 -uroot -pmysql

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| tracker_dev        |
| tracker_test       |
+--------------------+
6 rows in set (0.05 sec)

mysql> \q
Bye
```

## Flyway - MySQL Migration

```
$ docker-compose up flyway

$ docker rm databases_flyway_1
```

```
$ docker-compose -f docker-compose-test.yml up flyway
```

### Check

```
$ mysql -h127.0.0.1 -uroot -pmysql

mysql> use tracker_dev;
mysql> describe time_entries;
```
