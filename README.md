# docker-bigtop

* Hive with Apache Bigtop project

## Install

* [Running various Bigtop components](https://cwiki.apache.org/confluence/display/BIGTOP/Running+various+Bigtop+components)

## Build image

```
$ sudo ./build.sh
```

## Run image

* You can login Hadoop environment

```
$ sudo docker-compose -f docker-compose.yml up
$ sudo docker exec -it <container-name> /bin/bash
```

## Run Hive

* Hadoop already prepared hdfs user, please create some directories
    * You can also refer [Running various Bigtop components](https://cwiki.apache.org/confluence/display/BIGTOP/Running+various+Bigtop+components)

```
# su - hdfs
$ hadoop fs -mkdir /tmp
$ hadoop fs -mkdir -p /user/hive/warehouse
$ hadoop -chmod g+x /tmp
$ hadoop -chmod g+x /user/hive/warehouse
```
