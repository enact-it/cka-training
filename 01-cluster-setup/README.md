# Cluster setup

In this lab, we're going to set up our Kubernetes "cluster" using kubeadm.

## 1. Create a VM

## 2. Set up prerequisites using init.sh

## 3. Initialize the cluster

## 4. Add IP alias to /etc/hosts

Use `ip a` to get the IP address of the primary network interface. E.g., `192.168.1.201`.

Add the IP address to `/etc/hosts` with alias k8s-control-plane.

We do this to ensure certificates will continue to work, even if the IP address changes.

## 5. Create kubeadm-config.yaml

Use the provided content.

## 6. Initialize the control plane

```bash
kubeadm init --config=kubeadm-config.yaml --upload-certs| tee kubeadm-init.out
```

Take note of the output, we will need this to join a node later.

## 7. Set up kube config file

Drop back down to normal user level.

Create a new directory for our config.

```bash
mkdir -p $HOME/.kube
```

Copy over the config.

```bash
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

Ensure we have permissions to use it.

```bash
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Inspect the file. See what you can make out of it.

## 8. Set up Container Network Interface (CNI)

Add the Cilium helm repo
