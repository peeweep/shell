# From: https://github.com/mixool/script
#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# Usage:
## wget --no-check-certificate https://raw.githubusercontent.com/mixool/script/debian-9/hostloc.sh && chmod +x hostloc.sh.sh && bash hostloc.sh
### bash <(curl -s https://raw.githubusercontent.com/mixool/script/debian-9/hostloc.sh) ${username} ${password}

# user info: change them to yours or use parameters instead.
username="$1"
password="$2"

#
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"

# workdir
workdir="/root/hostloc_cookie"
[[ ! -d "$workdir" ]] && mkdir $workdir

function login() {
  echo 
  echo -n $(date) 登陆...
  data="mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1&fastloginfield=username&username=$username&cookietime=$(shuf -i 1234567-7654321 -n 1)&password=$password&quickforward=yes&handlekey=ls"
  curl -s -H "$UA" -c $workdir/cookie_$username --data "$data" "https://www.hostloc.com/member.php" | grep -o "www.hostloc.com" && echo -n $(date) 成功 || status="1"
  [[ $status -eq 1 ]] && echo -n $(date) 失败 && exit 1
}

function credit() {
  echo  
  creditall=$(curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/home.php?mod=spacecp&ac=credit&op=base" | grep -oE "积分: </em>\w*" | awk -F'[>]' '{print $2}')
  echo $(date) 目前积分为：$creditall
}

function view() {
  echo  
  echo -n $(date) 访问空间
  for((i = 6610; i <= 6630; i++))
  do
  echo -n .
  curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/space-uid-$i.html" | grep -o "最近访客" >/dev/null && count[i]=$i
  sleep 10 && [[ ${#count[*]} -eq 10 ]] && echo && break 
  done
  echo -n $(date) 完成
}

function main() {
  login
  credit
  view
  credit
  
  # clean
  rm -rf $workdir

  # exit
  echo 
  echo $(date) $username Accomplished.  Thanks!
}

main
