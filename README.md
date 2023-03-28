# brec_rclone
融合了一下bililive录播姬和rclone，现在准备弄两种部署方法，一种是docker-compose，另一种是我自己做的docker

## 前期准备

事先本地部署一次rclone，获得rclone.conf文件

因为rclone的挂载有时需要浏览器验证，而服务器上无法做到

具体的rclone.conf文件可以输入`rclone config file`查看

## docker-compose（不是很推荐）

因为这个的rclone挂载我没弄很明白，在加了healthcheck之后才保证了挂载成功之后在启动brec

如果brec在rclone成功挂载前就启动了，那就会丢失保存在云盘里的config文件

而使用healthcheck的命令是cat /rec/config.json，这就要求你在网盘中原本就有一份config文件

可以按照[Docker 镜像 - 安装使用 - B站录播姬](https://rec.danmuji.org/user/install/docker/#运行录播姬)中所说的，复制一份到网盘中

### 环境变量（必须）

查看.env文件，填写Network_Disk_Name，username，password三个字段

在rclone文件中放入rclone的配置文件rclone.conf

### 运行

在当前文件夹下运行`docker-compose up`直接启动
