修改自 [逗比的mtproxy脚本](https://github.com/ToyoDAdoubi/doubi/blob/master/mtproxy.sh)

增加功能: 定时修改端口为日期

示例: 
`tg://proxy?server=8.8.8.8&port=516&secret=your_key`

![](mtproxy.jpg)

使用
```
wget -N --no-check-certificate https://raw.githubusercontent.com/itworkonmypc/dotfiles/master/mtproxy/mtproxy.sh && chmod +x mtproxy.sh && sudo bash mtproxy.sh
```
立即修改端口
```
sudo bash mtproxy.sh update_port
```
