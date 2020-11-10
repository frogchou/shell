#!/bin/bash
#更新aria2的下载库
killall aria2c
ariaconf=/etc/aria2/aria2.conf
if [ ! -e ${ariaconf} ];then
	echo cannot found aria2 config file,stop update.
	exit 1
fi

list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" ${ariaconf}`" ]; then
	sed -i '$a bt-tracker='${list} ${ariaconf}
	echo add......
else
	sed -i "s@bt-tracker.*@bt-tracker=$list@g" ${ariaconf}
	echo update......
fi

aria2c --conf-path /etc/aria2/aria2.conf -D
if [ $?==0 ];then
	echo "操作完成"
else
	echo "操作失败"
fi
