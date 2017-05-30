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
RUN apt-get -y install bigtop-utils hadoop\*
# Get supervisor, sudo
RUN apt-get install -y supervisor sudo libpam-modules-bin

# Install the full Hadoop stack (or parts of it)
# You can add flume-* oozie\* hive\*

# Format the namenode for the first time
RUN /etc/init.d/hadoop-hdfs-namenode init

# if dirs have not been created on local fs
RUN mkdir -p /var/run/hive
RUN mkdir -p /var/lock/subsys

# Prepare "hadoop" user with "hdfs" group
RUN mkhomedir_helper hdfs

# Get hive modules
RUN wget -O /tmp/apache-hive-2.1.1-bin.tar.gz http://www-us.apache.org/dist/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz
RUN tar xvzf /tmp/apache-hive-2.1.1-bin.tar.gz -C /usr/local

RUN echo ""                                                        >> /etc/bash.bashrc
RUN echo "export HIVE_HOME=/usr/local/apache-hive-2.1.1-bin"	   >> /etc/bash.bashrc
RUN echo "export HIVE_CONF_DIR=\$HIVE_HOME/conf"		   >> /etc/bash.bashrc
RUN echo "export PATH=\$PATH:\$HIVE_HOME/bin"			   >> /etc/bash.bashrc
RUN echo "export CLASSPATH=\$CLASSPATH:/usr/local/hadoop/lib/*:."  >> /etc/bash.bashrc
RUN echo "export CLASSPATH=\$CLASSPATH:\$HIVE_HOME/lib/*:."	   >> /etc/bash.bashrc

RUN echo ""							   >> /var/lib/hadoop-hdfs/.bashrc
RUN echo "export PATH=\$PATH:\$HIVE_HOME/bin"			   >> /var/lib/hadoop-hdfs/.bashrc

## Running
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
