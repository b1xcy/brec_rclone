# brec_rclone
融合了一下bililive录播姬和rclone，现在准备弄两种部署方法，一种是docker-compose，另一种是我自己做的docker

## 前期准备

事先本地部署一次rclone，获得rclone.conf文件

因为rclone的挂载有时需要浏览器验证，而服务器上无法做到

具体的rclone.conf文件可以输入`rclone config file`查看

## docker-compose

因为这个的rclone挂载我没弄很明白，在加了healthcheck之后才保证了挂载成功之后在启动brec

如果brec在rclone成功挂载前就启动了，那就会丢失保存在云盘里的config文件

而使用healthcheck的命令是cat /rec/config.json，这就要求你在网盘中原本就有一份config文件

可以按照[Docker 镜像 - 安装使用 - B站录播姬](https://rec.danmuji.org/user/install/docker/#运行录播姬)中所说的，复制一份到网盘中

### 环境变量（必须）

查看.env文件，填写Network_Disk_Name，username，password三个字段

在rclone文件中放入rclone的配置文件rclone.conf

### 运行

在当前文件夹下运行`docker-compose up -d`直接启动

## docker

这次我自己用dockerfile构建了一个基于rclone的镜像

如需拉取镜像：

```
docker pull b1xcy/brec_rclone:v1.1
```

具体的挂载命令如下

```
docker run --rm \
    --volume <你rclone配置文件的位置>:/root/.config/rclone/ \
    --user $(id -u):$(id -g) \
    --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro \
    --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    -p <映射的端口号>:2356 \
    brec_rclone:v1.1 <rclone中设置的网盘名> <挂载位置> run --bind "http://*:2356" --http-basic-user <录播机登录名> --http-basic-pass <录播机登陆密码> <挂载位置>
```

给出例子：

```
docker run --rm \
    --volume /home/b1xcy/rclone:/root/.config/rclone/ \
    --user $(id -u):$(id -g) \
    --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro \
    --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    -p 2356:2356 \
    brec_rclone:v1.1 b1xcy:/ /rec run --bind "http://*:2356" --http-basic-user "username" --http-basic-pass "password" /rec
```

如有需要在外部访问容器内的录播文件，可以多挂载一个卷，仅需加一条

```
--volume /rec:/rec
```

即可

## 感谢

- [Rclone](https://rclone.org/):一个极其好用的同步工具

- [BililiveRecorder/BililiveRecorder: B站录播姬](https://github.com/BililiveRecorder/BililiveRecorder):一直在使用的录播工具

