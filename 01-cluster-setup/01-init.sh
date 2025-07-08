#!/bin/bash

sudo -i

# Setup script for Kubernetes on ubuntu

apt-get -y update && apt-get -y upgrade

# Install pre-requisites
apt install -y curl jq apt-transport-https vim git wget software-properties-common lsb-release ca-certificates

# disable swap
echo ""
echo "\033[4mDisabling Swap Memory.\033[0m"
echo ""
sudo swapoff -a
sudo sed -e '/swap/s/^/#/g' -i /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Add kernel modules for Kubernetes networking
modprobe overlay
modprobe br_netfilter

# Update sysctl settings for Kubernetes networking
tee /etc/sysctl.d/kubernetes.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Add Docker GPG key
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install containerd
apt-get update && apt-get install containerd.io -y

# Configure containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd

# Add Kubernetes repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes
apt-get update

# Install kubelet, kubeadm, and kubectl. We'll update these versions later
apt-get install -y kubelet=${kubernetes_version} kubeadm=${kubernetes_version} kubectl=${kubernetes_version}
apt-mark hold kubelet kubeadm kubectl

# Install helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg >/dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm

# Set the node-ip for kubelet
# sudo cat > /etc/default/kubelet << EOF
# KUBELET_EXTRA_ARGS=--node-ip="$(ip --json a s | jq -r '.[] | if .ifname == "ens5" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
# EOF

#setting IP in /etc/hosts and hostname" ####
sudo echo "${control_plane_ip} control-plane" >>/etc/hosts
sudo echo "${worker1_ip} worker1" >>/etc/hosts
sudo echo "${worker2_ip} worker2" >>/etc/hosts
sudo hostnamectl set-hostname ${hostname}

cat <<EOF | sudo tee /etc/profile.d/k8s.sh
#!/bin/bash
source <(kubectl completion bash) # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell

alias k=kubectl
complete -o default -F __start_kubectl k
EOF

echo "Rebooting in 10 seconds"
sleep 10
reboot
