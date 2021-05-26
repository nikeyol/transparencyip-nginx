#!/usr/bin/env bash

# change time zone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
timedatectl set-timezone Asia/Shanghai
rm /etc/yum.repos.d/CentOS-Base.repo
cp /vagrant/yum/*.* /etc/yum.repos.d/
mv /etc/yum.repos.d/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

yum install -y curl wget jq envsubst awk bash getent grep gunzip less openssl sed tar base64 basename cat dirname head id mkdir numfmt sort tee net-tools

echo 'set host name resolution'
cat >> /etc/hosts <<EOF
172.17.10.201 NIM1
172.17.10.202 NIM2
172.17.10.203 NIM3
EOF

cat /etc/hosts

echo 'set nameserver'
echo "nameserver 8.8.8.8">/etc/resolv.conf
cat /etc/resolv.conf

echo 'disable swap'
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

# disable firewall
setenforce 0


cp /vagrant/certificate/* /etc/ssl/nginx

# install the ca certificate dependency
yum install -y ca-certificates

# install n+ repo
wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo
yum install -y nginx-plus
systemctl enable nginx.service
service nginx start


