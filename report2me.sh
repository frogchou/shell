#!/bin/bash
datetime=`date +%Y%m%d%H%M%S`
reportfile=/tmp/reportfile$datetime
datestr=`date +%Y%m%d`

IP=`/sbin/ifconfig eth0 | grep "inet" | grep "netmask" |sed 's/^.*inet //g' |sed 's/ netmask.*$//g'`
echo "服务器当前内网IP地址："$IP"." >> ${reportfile}
OIP=`curl d.frogchou.com:8000`
echo "服务器当前外网IP地址："$OIP"." >> ${reportfile}

WIP=`sudo ifconfig wlan0 |grep "inet" | grep "netmask" |sed 's/^.*inet //g' |sed 's/ netmask.*$//g'`
echo "服务器当前WLAN地址："$WIP"." >> ${reportfile}

miroute_spase=`df -h | grep /mnt/route|awk '{print $5}'`
echo "存储硬盘使用空间达："${miroute_spase}"." >> ${reportfile}

root_spase=`df -h |grep /dev/root |awk '{print $5}'`
echo "服务器系统根分区使用空间达："${root_spase}"." >> ${reportfile}

#spider_file_count=`find /mnt/route/spiderpic/ -type f | wc -l`
#echo "蜘蛛爬取文件总数为："${spider_file_count}"." >> ${reportfile}

spider_getfile=`find /mnt/route/spiderpic/images/${datestr}/ -type f -cmin -1500 |wc -l`
echo "蜘蛛今日爬取文件总数为："${spider_getfile}"." >> ${reportfile}

spider_getdir=`find /mnt/route/spiderpic/images/${datestr} -type d -cmin -1500 |wc -l`
echo "蜘蛛今日创建目录总数为： "${spider_getdir}"." >> ${reportfile}

cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $6}' | cut -f 1 -d "."`
echo "服务器当前CPU使用率为："$cpu_idle"." >> ${reportfile}

swap_total=`free -m | grep Swap | awk '{print $2}'`
echo "服务器交换分区总量为："$swap_total"." >> ${reportfile}

swap_free=`free -m | grep Swap | awk '{print $4}'`
echo "服务器剩余交换分区为："$swap_free"." >> ${reportfile}

swap_used=`free -m | grep Swap | awk '{print $3}'`
echo "服务器已已使用交换分区为："$swap_used"." >> ${reportfile}

echo "前500尝试破解当前服务器IP地址排行：" >> ${reportfile}
lastb |head -500 |awk '{print $3}' |sort |uniq -c |sort -rn >> ${reportfile} 

cat ${reportfile} | mutt -s "raspberry pi_report" example@mail.com
cat ${reportfile}
