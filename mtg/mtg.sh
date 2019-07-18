#!/bin/bash

mtg_install() {
  url=$(
    curl -s https://api.github.com/repos/9seconds/mtg/releases/latest |
      grep "browser_download_url" | grep "mtg-linux-amd64" |
      cut -d '"' -f 4
  )
  mtg_path="/usr/bin/mtg"
  sudo wget "${url}" -O ${mtg_path} && sudo chmod +x ${mtg_path}
}

mtg_run() {
  bind_ip=$(ip a | grep inet | grep brd | cut -d " " -f 6 | cut -d "/" -f 1)
  public_ip=$(curl ip.sb)
  if ${bind_ip} == "${public_ip}"; then
    mtg --verbose "$(openssl rand -hex 16)" --public-ipv4 "${public_ip}" --bind-port 1620 --secure-only
  else
    mtg --verbose "$(openssl rand -hex 16)" --bind-ip "${bind_ip}" --bind-port 1620 --secure-only
  fi
}

mtg_install
# mtg_run

# mtg -d "$(openssl rand -hex 16)" --bind-ip 0.0.0.0 --bind-port 1620 --secure-only
curTime=$(date +%Y%m%d%H%M%S)
sudo mkdir ~/.mtg/
mtg "$(openssl rand -hex 16)" --bind-ip 0.0.0.0 --bind-port 1620 --secure-only |
  tee ~/.mtg/${curTime}.log
v4_tgurl=$(grep tg_url ~/.mtg/${curTime}.log | cut -d '"' -f 4 | sed -n 1p)
v6_tgurl=$(grep tg_url ~/.mtg/${curTime}.log | cut -d '"' -f 4 | sed -n 2p)

if v4_tgurl == ''; then
  echo "1"
elif v6_tgurl = ''; then
  echo '2'
else
  echo '3'
fi
