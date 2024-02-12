#!/bin/bash
kubeadm init --control-plane-endpoint control-plane --pod-network-cidr=192.168.0.0/16
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml