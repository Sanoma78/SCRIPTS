#!/bin/bash
# To Collect CPU, Memery and Disk usage report from multiple servers
#  Author: Saint Anoma
#  Website: asczone.com servers
## format: Hostname, Date&Time, CPU%, Mem%, Disk%

HOSTNAME=$(hostname)
DATET=$(date "+%Y-%m-%d %H:%M:%S")
CPUSAGE=$(top -b -n 2 -d1 |grep "Cpu (s)" |awk '{print $2}'|awk -F. '{print $1}')
MEMOUSAGE=$(free |grep Mem |awk '{print $3/$2 * 100.0}')
DISKUSAGE=$(df -P |column -t |awk '{print $5}' | tail -n 1 |sed 's/%//g')

echo 'HostName,  Date&Time,   CPU(%),   Mem(%),   Disk(%)' >> /opt/usagereport
echo "$HOSTNAME, $DATET, $CPUSAGE, $MEMOUSAGE, $DISKUSAGE" >> /opt/usagereport

for i in 'cat /root/ansadmin/Scripts/HostList';
do
HOSTNAME=$(ssh -i hostname)
DATET=$(ssh $i 'date +%Y-%m-%d %H:%M:%S')
CPUSAGE=$(ssh $i top -b -n 2 -d1 |grep "Cpu (s)" |awk '{print $2}'|awk -F. '{print $1}')
MEMOUSAGE=$(ssh $i free |grep Mem |awk '{print $3/$2 * 100.0}')
DISKUSAGE=$(ssh $i df -P |column -t |awk '{print $5}' | tail -n 1 |sed 's/%//g')

echo "$RHOSTNAME, $RDATET, $RCPUSAGE, $RMEMOUSAGE, $RDISKUSAGE" >> /opt/usagereport
done
