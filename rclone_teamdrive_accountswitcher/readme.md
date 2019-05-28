你需要先将所有的小号加入同一个Team Drvie，每个帐号每天可以上传750G。\
此脚本可以自动切换帐号\
挂载时需要命名为 1 2 3, 以此类推，先用1 帐号复制
Example:
``` txt
Current remotes:

Name    Type
================
1       drive
2       drive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> 
```

如果你当前没有rclone 进程，需要先手动运行一次此脚本
然后可以加入cron, 10分钟运行一次
```shell
crontab -e
*/10 * * * * /usr/bin/bash rclone_monitor.sh 
```
