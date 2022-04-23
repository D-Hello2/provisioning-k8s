#!/bin/bash
echo "This script was created by danidwiaryaputra for learning purposes, this script will install required package for k8s node master or node worker, please enjoy!"
sleep 5

read -p  "Do you want to update your System (yes/no)? " update

if [ $update == yes ]
then
  echo "########### update system ###########"
  echo ""
  sudo apt update
  echo ""
  echo "########### done ###########"
  echo ""
elif [ $update == no ]
then
  echo "OK, your system will not be updated"

else
  echo "please input yes/no"
fi

echo "########### add key and repo k8s ###########"
echo ""
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "########### done ###########"
echo ""

echo "########### Install kubelet, kubeadm and kubectl ###########"
echo ""
  sudo apt update
  sudo apt -y install kubelet kubeadm kubectl
  sudo systemctl enable kubelet
echo "########### done ###########"
echo ""

echo " Your k8s package was installed, please check with kubectl tool if k8s work properly "
sleep 5

echo "########### Disable Swap  ########### "
echo ""
sudo swapon -s
sudo swapoff -a
echo "########### done  ###########" 
echo ""


echo "########### Enable Kernel Modules ###########"
echo ""
sudo modprobe overlay
sudo modprobe br_netfilter
echo "###########  done ###########"
echo ""

echo "########### Add some settings to sysctl ########### "
echo ""
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
echo "########### done ########### "
echo ""

echo "########### Reload sysctl ###########"
echo ""
sudo sysctl --system
echo "########### done ###########"
echo ""

echo "########### Install Docker and configure docker ###########"
echo ""
sudo apt install docker-compose -y
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
echo "########### done ###########"
echo ""

echo "########### restart service docker ###########"
echo ""
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
echo "########### done ###########"
echo ""


