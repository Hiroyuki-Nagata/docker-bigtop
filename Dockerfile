#
# how i install bigtop 1.1.0 on ubuntu 16.04
# https://gist.github.com/tonycox/322e8ffa584123f1b498c705cf5d972f
#
FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y upgrade

# install java (homedir - /usr/lib/jvm/java-8-oracle/)
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN apt-get -y install openjdk-8-jdk maven wget

# Run maven test
RUN mvn -v

# Install the Apache Bigtop GPG key
RUN wget -O- http://archive.apache.org/dist/bigtop/bigtop-1.2.0/repos/GPG-KEY-bigtop | apt-key add -

# Make sure to grab the repo file:
RUN wget -O /etc/apt/sources.list.d/bigtop-1.2.0.list http://archive.apache.org/dist/bigtop/bigtop-1.2.0/repos/ubuntu16.04/bigtop.list

# Update the apt cache
RUN apt-get -y update

# Install bigtop-utils
RUN apt-get -y install bigtop-utils

# Install the full Hadoop stack (or parts of it)
# You can add flume-* oozie\*
RUN apt-get -y install hadoop\* hive\*

# Format the namenode for the first time
RUN /etc/init.d/hadoop-hdfs-namenode init

# if dirs have not been created on local fs
RUN mkdir -p /var/run/hive
RUN mkdir -p /var/lock/subsys

# Get supervisor, sudo
RUN apt-get install -y supervisor sudo libpam-modules-bin

# Prepare "hadoop" user with "hdfs" group
RUN mkhomedir_helper hdfs

## Running
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
