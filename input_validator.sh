#!/bin/bash
echo '[?] IP (validating):' $1
if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "[+] IP OK "
else
    echo "[-] INVALID IP"
    exit 1
fi

echo '[?] PORT (validating):' $2
re='^[0-9]+$'
if ! [[ $2 =~ $re ]]; then
    echo "[-] INVALID PORT" 2>&1
    exit 1
else
    lsof -i:$2 2>&1 >/dev/null
    if [ $? == 1 ]; then
        echo "[+] PORT OK"
    else
        echo "[-] UNAVAILABLE PORT"
        exit 1
    fi
fi
