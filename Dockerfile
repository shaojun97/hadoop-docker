FROM ubuntu:20.04 AS base

LABEL maintainer="yiyun <yiyungent@gmail.com>"

# 设置国内阿里云镜像源
COPY etc/apt/aliyun-ubuntu-20.04-focal-sources.list   /etc/apt/sources.list

# 时区设置
ENV TZ=Asia/Shanghai

RUN apt-get update

# 1. 安装常用软件
RUN apt-get install -y wget
RUN apt-get install -y ssh
RUN apt-get install -y vim
RUN apt-get install -y unzip
# openssh-server 用于宿主机 SSH 连接 Docker 内 Ubuntu
RUN apt-get install openssh-server

# 2. 安装 Java
ADD jdk-8u131-linux-x64.tar.gz /opt/
RUN mv /opt/jdk1.8.0_131 /opt/jdk1.8
ENV JAVA_HOME=/opt/jdk1.8
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH=${JAVA_HOME}/bin:$PATH

# 3. 安装 Hadoop
ADD hadoop-2.7.3.tar.gz /opt/
RUN mv /opt/hadoop-2.7.3 /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin
# 3.1 Hadoop伪分布式配置
COPY hadoop-config/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml
COPY hadoop-config/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
COPY hadoop-config/mapred-site.xml /opt/hadoop/etc/hadoop/mapred-site.xml
COPY hadoop-config/yarn-site.xml /opt/hadoop/etc/hadoop/yarn-site.xml
# 3.2 Java环境变量
COPY hadoop-config/hadoop-env.sh /opt/hadoop/etc/hadoop/hadoop-env.sh
# 3.3 配置完成后，执行 NameNode 的格式化
RUN /opt/hadoop/bin/hdfs namenode -format
# 3.4 修改 SSH 配置文件, 以便宿主机 SSH 连接 Docker 内 Ubuntu
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# 3.5 配置 SSH 免密登录
RUN /etc/init.d/ssh start
RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 4. 配置 Hadoop 集群: 3节点: 替换容器ip地址
COPY hadoop-config/hosts /etc/hosts

