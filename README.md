About this container
---
[![Docker Build Status](https://img.shields.io/docker/build/cturra/ntp.svg)](https://hub.docker.com/r/cturra/ntp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/cturra/ntp.svg)](https://hub.docker.com/r/cturra/ntp/)
[![Apache licensed](https://img.shields.io/badge/license-Apache-blue.svg)](https://raw.githubusercontent.com/cturra/docker-ntp/master/LICENSE)

This container runs [OpenNTPD](http://www.openntpd.org/index.html) on [Alpine Linux](https://alpinelinux.org/). More about NTP can be found at:

  http://www.ntp.org



## Dockerfile
```Dockefile
FROM cturra/ntp

RUN apk add -U tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY ntpd.conf /etc/ntpd.conf
```


Running via Docker
---
Pull and run -- it's this simple.

```
# run ntp via docker
$> docker run --name=ntp             \
              --restart=always       \
              --detach=true          \
              --publish=123:123/udp  \
              --cap-add=SYS_NICE     \
              --cap-add=SYS_RESOURCE \
              --cap-add=SYS_TIME     \
              harbor.cedarhd.com/cturra/ntp
```
**需要注意的是：
1、由于这里给定了--cap-add SYS_TIME，ntp容器具有权限修改宿主机系统时钟和硬件时钟，其内容运行的ntp进程会自动帮我们同步网络时间到容器和宿主机；
2、宿主机上不应该再运行任何时间同步进程，比如systemd-timesyncd，ntpd等 **

执行如下命令来禁用宿主机的时间同步服务：
```bash
systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd
```

Building and Running with Docker Compose
---
Using the docker-compose.yml file included in this git repo, you can build the container yourself (should you choose to).
*Note: this docker-compose files uses the `3.4` compose format, which requires Docker Engine release 17.09.0+

```
# build ntp
$> docker-compose build ntp

# run ntp
$> docker-compose up -d ntp

# (optional) check the ntp logs
$> docker-compose logs ntp
```


Building and Running with Docker Engine
---
Using the vars file in this git repo, you can update any of the variables to reflect your
environment. Once updated, simply execute the build then run scripts.

```
# build ntp
$> ./build.sh

# run ntp
$> ./run.sh
```


Test NTP
---
From any machine that has `ntpdate` you can query your new NTP container with the follow
command:

```
$> ntpdate -q <DOCKER_HOST_IP>
```


Here is a sample output from my environment:

```
$> ntpdate -q 10.13.13.9
server 10.13.13.9, stratum 3, offset 0.010089, delay 0.02585
17 Sep 15:20:52 ntpdate[14186]: adjust time server 10.13.13.9 offset 0.010089 sec
```

If you see a message, like the following, it's likely the clock is not yet synchronized.
```
$> ntpdate -q 10.13.13.9
server 10.13.13.9, stratum 16, offset 0.005689, delay 0.02837
11 Dec 09:47:53 ntpdate[26030]: no server suitable for synchronization found
```

To see details on the ntpd status, you can check with the below command on your
docker host:
```
$> docker exec ntp ntpctl -s status
4/4 peers valid, clock synced, stratum 2
```


## Setup ntp client side
see  https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-16-04

### setup ntp-server address (centos)

```bash
vim /etc/ntp.conf
pool ntp-server0.cedarhd.com
systemctl restart ntp
```

#### setup ntp client for ubuntu16
```bash
## configure ntp server address
vim /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd
systemctl enable systemd-timesyncd
## enable ntp sync
timedatectl set-ntp yes
```





