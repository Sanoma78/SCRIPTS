#!/bin/bash
# Script for install Zabbix Agent on CentOS 7/8.
# github.com/@olmosleo
#SELINUX="/etc/selinux/config";

#echo "SELINUX=disabled" > $SELINUX;
#echo "SELINUXTYPE=targeted" >> $SELINUX;
# remember to reboot after install or just restart the machine when you finish to execute the script.
# Disabled SELINUX

################################ Install the Zabbix Agent 5.2 ###################################

#sudo rpm -Uv   rpm -Uvh https://repo.zabbix.com/zabbix/5.2/rhel/8/x86_64/zabbix-release-5.2-1.el8.noarch.rpm
sudo  rpm -Uvh https://repo.zabbix.com/zabbix/5.2/rhel/8/x86_64/zabbix-release-5.2-1.el8.noarch.rpm
# update 3.4
#sudo rpm -Uv  rpm -Uvh https://repo.zabbix.com/zabbix/5.2/rhel/8/x86_64/zabbix-release-5.2-1.el8.noarch.rpm


sudo yum install -y zabbix-agent
#sudo sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"

################################# Edit the file conf #############################################
# edit file /etc/zabbix/zabbix_agentd.conf and add this change
ZABBIX_AGENT_CONF="/etc/zabbix/zabbix_agentd.conf";
ZABBIX_SERVER="192.168.0.44";
# add some params to the configure file of zabbix-agent
echo "PidFile=/var/run/zabbix/zabbix_agentd.pid" >> $ZABBIX_AGENT_CONF;
echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> $ZABBIX_AGENT_CONF;
echo "LogFileSize=0" >> $ZABBIX_AGENT_CONF;
echo "Server=$ZABBIX_SERVER" >> $ZABBIX_AGENT_CONF;
echo "ServerActive=$ZABBIX_SERVER" >> $ZABBIX_AGENT_CONF;
echo "Hostname=Zabbix server" >> $ZABBIX_AGENT_CONF;
echo "Include=/etc/zabbix/zabbix_agentd.d/" >> $ZABBIX_AGENT_CONF;
# Server=your_zabbix_server_ip_address
# TLSConnect=psk
# TLSPSKIdentity=PSK 001
# TLSPSKFile=/etc/zabbix/zabbix_agentd.psk

############## Add Firewall Rules #####################################

# Open port 10050 on firewall (iptables) Only for CentOS 7
#PORT=10050;
# remember to hability the port in the local firewall.
#firewall-cmd --permanent --add-port=$PORT/tcp
firewall-cmd --permanent --add-port=10050/tcp
sudo systemctl restart firewalld

# Open port 10050 on firewall (iptables) Only for CentOS 6.X
#sudo iptables -I INPUT -p tcp -m tcp --dport $PORT -j ACCEPT
##udo iptables -I INPUT -p udp -m udp --dport $PORT -j ACCEPT

#sudo iptables -A INPUT -m state --state NEW -p tcp --dport $PORT -j ACCEPT
#sudo iptables -A INPUT -m state --state NEW -p udp --dport $PORT -j ACCEPT
#sudo service iptables save

######################################################################
#### Restart the services ############################################
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
######################################################################
#sudo service zabbix-agent restart

sudo chkconfig zabbix-agent on
