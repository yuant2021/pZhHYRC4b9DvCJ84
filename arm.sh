#!/bin/bash

bbr(){
    cat > /etc/sysctl.conf <<EOF
fs.file-max = 1024000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_rmem = 4096 65536 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_fastopen = 3
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
    sysctl -p && sysctl --system
}

init_tunnel(){
    local sysarch="$(uname -m)"
    if [ "${sysarch}" = "unknown" ] || [ "${sysarch}" = "" ]; then
        local sysarch="$(arch)"
    fi
    if [ "${sysarch}" = "x86_64" ]; then
        # X86平台 64位
        wget https://github.com/nkeonkeo/neko-relay-land/releases/latest/download/neko-relay_linux_amd64 -O /usr/bin/neko-relay
        elif [ "${sysarch}" = "armv7l" ] || [ "${sysarch}" = "armv8" ] || [ "${sysarch}" = "armv8l" ] || [ "${sysarch}" = "aarch64" ]; then
        # ARM平台 暂且将32位/64位统一对待
        wget https://github.com/nkeonkeo/neko-relay-land/releases/latest/download/neko-relay_linux_arm64 -O /usr/bin/neko-relay
    fi
    
    chmod +x /usr/bin/neko-relay
    neko-relay -g init
}

init_config(){
    wget https://raw.githubusercontent.com/yuant2007/tunnel_config/main/neko_config.yaml?token=GHSAT0AAAAAABPTEPV4NELVKMF7WTCNDAYOYQE7Q6A -O /etc/neko-relay/config.yaml
    neko-relay -g restart
}


ddns(){
    echo -n "请输入域名前缀:"&&read dom
    ip="$(curl -fsL4 ip.sb)"
    if [ "$dom" = "awshk01" ]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent tzconn.gfw.plus 443 9cdfb793551d515ce9 --tls
        curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=290979,f2d230d801cbdd22fb409053a0b6252c&format=json&domain_id=90286247&record_id=1047169451&record_line=默认&sub_domain=awshk01'
        elif [ "$dom" = "awshk02" ]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent tzconn.gfw.plus 443 5cbca093e371f80552 --tls
        curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=290979,f2d230d801cbdd22fb409053a0b6252c&format=json&domain_id=90286247&record_id=1050334284&record_line=默认&sub_domain=awshk02'
        elif [ "$dom" = "awsjp01" ]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent tzconn.gfw.plus 443 9e05bf741785095af0 --tls
        curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=290979,f2d230d801cbdd22fb409053a0b6252c&format=json&domain_id=90286247&record_id=1047893622&record_line=默认&sub_domain=awsjp01'
        elif [ "$dom" = "awssg01" ]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent tzconn.gfw.plus 443 5a0e58b8552cf34bd8 --tls
        curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=290979,f2d230d801cbdd22fb409053a0b6252c&format=json&domain_id=90286247&record_id=1049484405&record_line=默认&sub_domain=awssg01'
    fi
}


ddns
bbr
init_tunnel
init_config
