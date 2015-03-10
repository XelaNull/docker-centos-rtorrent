#!/bin/sh
## Container start up script for httpd and rtorrent
##
echo "Starting apache ..."
/usr/sbin/httpd -k start
echo ""
echo "Starting rtorrent ..."
rtorrent -n -o import=/config/rtorrent.conf
