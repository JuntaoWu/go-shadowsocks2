# go-shadowsocks2

A fresh implementation of Shadowsocks in Go.

GoDoc at https://godoc.org/github.com/shadowsocks/go-shadowsocks2/

[![Build Status](https://travis-ci.com/shadowsocks/go-shadowsocks2.svg?branch=master)](https://travis-ci.com/shadowsocks/go-shadowsocks2)


## Features

- [x] SOCKS5 proxy with UDP Associate
- [x] Support for Netfilter TCP redirect (IPv6 should work but not tested)
- [x] UDP tunneling (e.g. relay DNS packets)
- [x] TCP tunneling (e.g. benchmark with iperf3)
- [x] SIP003 plugins


## Install

Pre-built binaries for common platforms are available at https://github.com/shadowsocks/go-shadowsocks2/releases

Install from source

```sh
go get -u -v github.com/shadowsocks/go-shadowsocks2
```


## Basic Usage

### Server

Start a server listening on port 8488 using `AEAD_CHACHA20_POLY1305` AEAD cipher with password `your-password`.

```sh
docker run --restart=always -dt -p 8488:8488 mritd/shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose
```

## Advanced Usage

### SIP003 Plugins (Experimental)

Both client and server support SIP003 plugins.
Use `-plugin` and `-plugin-opts` parameters to enable.

Client:

```sh
go-shadowsocks2 -c 'ss://AEAD_CHACHA20_POLY1305:your-password@[server_address]:8488' \
    -verbose -socks :1080 -u -plugin v2ray
```
Server:

```sh
go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose \
    -plugin v2ray -plugin-opts "server"
```
Note:

It will look for the plugin in the current directory first, then `$PATH`.

UDP connections will not be affected by SIP003.

### Reuse Detection

This feature used for resistance with reuse attack by checking cipher salt/iv is repeated.

Expose some environment variables below to control this feature:
- `SHADOWSOCKS_SF_CAPACITY`(an integer): The most recently salt items to keep for checking duplication. Default 1e6, 
on gave a non-positive integer this feature will be disabled;
- `SHADOWSOCKS_SF_FPR`(decimal): False positive rate of the filter, 0.0003 means 0.03% FPR. Default 1e-6;
- `SHADOWSOCKS_SF_SLOT`(a positive integer): All the salt items will be added into lots(how many this variable defines) 
filter items for the check. Default 10.


```sh
SHADOWSOCKS_SF_CAPACITY=1e6 SHADOWSOCKS_SF_FPR=1e-6 SHADOWSOCKS_SF_SLOT=10 go-shadowsocks2 ...
```

## Design Principles

The code base strives to

- be idiomatic Go and well organized;
- use fewer external dependences as reasonably possible;
- only include proven modern ciphers;