---
title: Redis 基础
date: 2018-04-10
tags: 备忘
---
---
date：2018年4月19日
---


### 源码安装 
- 下载
```
 wget http://download.redis.io/releases/redis-stable.tar.gz
```
- 解压
```
tar -xzvf redis-stable.tar.gz
mv redis-stable redis
```
- 编译
```
cd redis
make
```
- 修改配置reids.conf
```
bind 127.0.0.1 --> 0.0.0.0 # 运行远程访问
daemonize no --> yes # 后台运行
database 16 # 库的数量
```
- 启动
```
src/redis-server redis.conf
```
- 停止
```
src/redis-cli 
shutdown
exit
```

---

### apt 
- 安装
```
apt-get install redis-server
# 安装完成就直接启动了, 默认读取的配置文件在/etc/redis/redis.conf
```
- 停止
```
systemctl stop redis-server
```
 
---
  
### Docker
- 基本命令
```
docker pull redis 
docker run -p 6380:6379 redis # 运行redis镜像映射到主机的6380端口
docker sp -a # 查看容器运行状态
docker start xx # 启动
docker restart xx # 重启容器
docker stop xx # 停止
```
- 使用自定义的配置文件[（完整的配置描述）](https://raw.githubusercontent.com/antirez/redis/8ac7af1c5d4d06d6c165e35d67a3a6a70e5d98c3/redis.conf)
```
docker run -v /home/ubuntu/redis.conf:/usr/local/etc/redis/redis.conf -p 6379:6379 redis redis-server /usr/local/etc/redis/redis.conf
// 注意修改配置中的数据库文件路径 如：dir ./
```


---

### 常用数据结构
- [Strng](http://redisdoc.com/string/index.html)

- [Hash](http://redisdoc.com/hash/index.html)

- [List](http://redisdoc.com/list/index.html)

- [Set](http://redisdoc.com/set/index.html)

- [SortedSet](http://redisdoc.com/sorted_set/index.html)

---

### 订阅 & 发布
- 所有的订阅都是全局的。
- 当你为一个渠道多次订阅时，这个渠道的每次消息发布，会收到多条订阅。
- 订阅的消息可以是呈队列有序，也可以是并行的

---

### 事务 
- redis 不支持回滚
- 事务是用来保证即使你有命令的连续执行，在多并发的情况下，希望几条命令是联系执行的时候使用事务。
- 事务中的多条命令中有一条或者以上的命令存在语法错误，那么正确的命令即使是 `EXEC` 也不会被执行 *（在Redis 2.6.5之后）* 。但是需要注意的是这种错误的事务机制仅限于语法错误。
- `DISCARD` 用来放弃事务, 在执行到 `DISCARD` 的时候全部的命令将被放弃。如果正在使用 `WATCH` 命令监视某个(或某些) key，那么取消所有监视，等同于执行命令 `UNWATCH` 。
- `WATCH` 命令可以为 Redis 事务提供 check-and-set 行为。
被 `WATCH` 的键会被监视，并会发觉这些键是否被改动过了。 如果有至少一个被监视的键在 EXEC 执行之前被修改了， 那么整个事务都会被取消，set执行失败。
- [如何在C#中使用事务](https://github.com/sc1994/.NET-Learn/blob/master/Redis/RedisDemo/Transactions%20in%20Redis.md)(使用StackExchange.Redis)

---

### Redis 集群
- Redis 集群是一个分布式（distributed）、容错（fault-tolerant）的 Redis 实现， 集群可以使用的功能是普通单机 Redis 所能使用的功能的一个子集（subset）。
- Redis 集群中不存在中心（central）节点或者代理（proxy）节点， 集群的其中一个主要设计目标是达到线性可扩展性（linear scalability）。
- Redis 集群为了保证一致性（consistency）而牺牲了一部分容错性： 系统会在保证对网络断线（net split）和节点失效（node failure）具有有限抵抗力的前提下， 尽可能地保持数据的一致性。

---

### 索引
- 跳跃表
```
在跳跃表是由N层链表组成，最底层是最完整的的数据，每次数据插入，率先进入到这个链表（有序的），
插入完成后，通过抛硬币的算法，判断是否将数据向上层跑，如果是1的话，就抛到上层，然后继续抛硬盘，
判断是否继续向上层抛，直到抛出了0结束整个操作，每抛到一层的时候，如果当前层没有数据，就构造一个链表，
将数据放进去，然后使用指针指向来源地址，就这样依次类推，形成了跳跃表，每次查询，从最上层遍历查询，
如果找到就返回结果，否则就在此层找到最接近查询的值，将查询操作移到另外一层，就是刚才说到来源地址，
所在层，重复查询。
```
![image](http://118.24.27.231:8088/v2-114f4895c296861aca549d96fc4b563f_r.jpg)

- 单线程
```
单线程的模式解决了数据存储的顽疾：数据并发安全，任何运行多线程同时访问数据库都会存在这个问题。
所以才有了mysql的mvcc和锁， Memcached 的cas 乐观锁，来保证数据不会出现并发导致的数据问题。
但是redis 使用单线程就不存在这个问题：
    1：单线程足够简单，无论在redis的实现还是作为调用方，都不需要为数据并发提心吊胆，不需要加锁。
    2：不会出现不必要的线程调度，你知道多线程，频繁切换上下文，也会带来很多性能消耗。
```

- 多路 I/O 复用模型
```
多路 I/O 复用模型，这个也是java 的NIO体系使用的IO模型，也是linux诸多IO模型中的一种。
说白了就是当一个请求来访问redis后，redis去组织数据要返回给请求，这个时间段，redis的请求入口不是阻塞的。
其他请求可以继续向redis发送请求，等到redis io流完成后，再向调用者返回数据。
这样一来，单线程也不怕会影响速度了。
```
---

### 缓存击穿
- 什么是缓存击穿
```
缓存一般作为RDS的前置系统和服务器直连，减轻rds的负担，常理而言。
如果服务器查询缓存而不得的话，需要从rds中获取然后更新到缓存中，但是如果在“从rds中获取然后更新到缓存中”，
这个阶段，缓存尚未更新成功，大量请求进来的话，rds势必压力暴增，甚至雪崩，或者歹人恶意攻击，
一直查询rds和缓存中未存在key，也会导致缓存机制失效，rds压力暴增，称之为缓存击穿
```
