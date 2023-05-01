#!bin/ash
mkdir /${2}
rclone mount ${1} ${2} --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000 --vfs-cache-max-size 8G --vfs-cache-max-age 3m --vfs-cache-mode writes &
shift 2
sleep 60
dotnet ./brec/BililiveRecorder.Cli.dll $*
