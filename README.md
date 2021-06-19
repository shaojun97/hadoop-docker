

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
docker run -it -h master --name master -p 50070:50070 -p 18088:18088 my-hadoop

docker run -it -h slave01 --name slave01 my-hadoop

docker run -it -h slave02 --name slave02 my-hadoop
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


> 在容器外部可通过下方获取所在容器名称及ip

```bash
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```

