#!/bin/sh
#go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose
if [ "${SS_CONFIG}" != "" ]; then
    exec go-shadowsocks2 -s ${SS_CONFIG} 
else
    exec go-shadowsocks2 $@
fi