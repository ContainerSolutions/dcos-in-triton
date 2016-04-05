# Setting up DCOS in Triton instances manually:
Create three instances and selected "near" placement. Then ssh into the boxes and:

```
systemctl stop firewalld && systemctl disable firewalld
```

```
yum update -y
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml
```

Check if new kernel is at position 1

```
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
```

Then

```
grub2-set-default <position count starts with 0>
```

And finally

```
reboot
```

### On Master & Bootstrap
```
curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl enable docker
```

### Enable overlayfs

```
mkdir -p /etc/systemd/system/docker.service.d
tee /etc/systemd/system/docker.service.d/storage.conf <<-'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --storage-driver=overlay
EOF

systemctl daemon-reload
systemctl restart docker
```

### On bootstrap

```
docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 -v /var/zookeeper/dcos:/tmp/zookeeper --name=dcos_int_zk jplock/zookeeper
docker pull nginx
```

### On Master & Agent

```
yum install -y tar xz unzip curl

sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config &&
sudo groupadd nogroup &&
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 &&
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 &&
sudo reboot
```

### On bootstrap

```
mkdir -p genconf && cd genconf

tee /root/genconf/ip-detect <<-'EOF'
#!/usr/bin/env bash
set -o nounset -o errexit
export PATH=/usr/sbin:/usr/bin:$PATH
echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
EOF

chmod +x ip-detect

tee /root/genconf/config.yaml <<-'EOF'
agent_list:
- 10.224.6.76
bootstrap_url: http://10.224.6.229:8888
cluster_name: DCOS
exhibitor_storage_backend: static
master_discovery: static
master_list:
- 10.224.1.78
process_timeout: 10000
resolvers:
- 8.8.8.8
- 8.8.4.4
ssh_port: 22
ssh_user: core
superuser_password_hash: none
superuser_username: none
EOF

cd /root

wget https://s3.amazonaws.com/downloads.mesosphere.io/dcos/testing/CM.7/dcos_generate_config.sh

bash dcos_generate_config.sh

docker run -d -p 8888:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx
```

### On master

```
mkdir /tmp/dcos && cd /tmp/dcos
curl -O http://10.224.6.229:8888/dcos_install.sh
bash dcos_install.sh master
```

### On Agent

```
mkdir /tmp/dcos && cd /tmp/dcos
curl -O http://10.224.6.229:8888/dcos_install.sh
bash dcos_install.sh slave
```
