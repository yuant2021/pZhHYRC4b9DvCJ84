#!/bin/bash

xrayr_install(){
    bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
}

xrayr_config(){
    sed -i 's/SSpanel/V2board/g' /etc/XrayR/config.yml
    sed -i 's/http\:\/\/127.0.0.1:667/https\:\/\/api\.exl\.ink/g' /etc/XrayR/config.yml
    sed -i 's/123/vK3PRLJUJ7jBkrqxxHu65rvayE7BjRHqbFTTPkpGaxF49JTfJVTA6mun3bEhYbp4/g' /etc/XrayR/config.yml
    echo -n '请输入节点ID:'&&read id
    sed -i "s/41/$id/g" /etc/XrayR/config.yml
    sed -i "s/V2ray/Shadowsocks/g" /etc/XrayR/config.yml
    XrayR restart
}

xrayr_install
xrayr_config
