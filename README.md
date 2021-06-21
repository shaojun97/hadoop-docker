

# 构建准备

> 以下文件放于 项目根目录

- jdk-8u131-linux-x64.tar.gz
- hadoop-2.7.3.tar.gz

# 启动 Docker


> 构建镜像

```bash
docker build -t my-hadoop .
```

> 从镜像中启动一个容器

```bash
docker run -it -h master --name master -p 50070:50070 -p 18088:18088 -p 50075:50075 -p 50010:50010 -p 9000:9000 -p 2222:22 my-hadoop

docker run -it -h slave01 --name slave01 my-hadoop

docker run -it -h slave02 --name slave02 my-hadoop
```

> 50075 端口 用作 从 HDFS Browse file system 下载文件
> 50010 端口 用于 宿主机访问 DataNode, 不然可能会导致大文件上传HDFS失败

> 再次启动

```bash
docker start -i master
```

# 启动 Hadoop

> 进入容器中，执行命令

> 启动ssh

```bash
/etc/init.d/ssh start
```

> 接着开启 NameNode 和 DataNode 守护进程

```bash
start-all.sh
```

```bash
jps
```

- http://localhost:50070
- http://localhost:18088



# 补充


> 注意：默认 HDFS API 端口为 9000, 配置在 core-site.xml
> master 为 主机名 (hostname)

```xml
<configuration>
	<property>
        <name>fs.defaultFS</name>
        <value>hdfs://master:9000</value>
    </property>
    <property> 
        <name>hadoop.tmp.dir</name> 
        <value>/home/hadoop/temp</value>
    </property>
</configuration>
```


> 在容器外部可通过下方获取所在容器名称及ip

```bash
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```

