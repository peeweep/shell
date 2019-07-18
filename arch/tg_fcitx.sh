#!/bin/bash
before='Exec=telegram-desktop -- %u'
after='Exec=env QT_IM_MODULE=fcitx telegram-desktop -- %u'
file='/usr/share/applications/telegramdesktop.desktop'
sudo sed -i "s/${before}/${after}/g" ${file}
