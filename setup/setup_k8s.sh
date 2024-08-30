#!/bin/bash

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

sudo cp containerd.toml /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl mask --now swap.target
sudo swapoff -a
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

kubeadm config print init-defaults > kubeadm-config.yaml
sed -i -e "s/1.2.3.4/$PEGASUS_IP_SERVER/g" kubeadm-config.yaml
sed -i -e "s/name: node/name: $PEGASUS_K8S_NODE/g" kubeadm-config.yaml
sed -i -e "s=serviceSubnet: 10.96.0.0/12=serviceSubnet: 10.96.0.0/12\n  podSubnet: 10.244.0.0/16=g" kubeadm-config.yaml
sudo kubeadm config images pull --config kubeadm-config.yaml
sudo kubeadm init --config=kubeadm-config.yaml | tee kubeadm-init.log
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint node $PEGASUS_K8S_NODE node-role.kubernetes.io/control-plane-
cd k8s-nginx
kubectl create secret generic nginx-certs-keys --from-file=./nginx.crt --from-file=./nginx.key

sudo crictl pull docker.io/pdlan/pause
sudo crictl pull docker.io/pdlan/pegasus-artifact-local-proxy-nginx
sudo crictl pull docker.io/pdlan/pegasus-artifact-microbenchmark-cv
sudo crictl pull docker.io/pdlan/pegasus-artifact-microbenchmark-http-client
sudo crictl pull docker.io/pdlan/pegasus-artifact-microbenchmark-memcached
sudo crictl pull docker.io/pdlan/pegasus-artifact-microbenchmark-redis
sudo crictl pull docker.io/pdlan/pegasus-artifact-microbenchmark-tcp
sudo crictl pull docker.io/pdlan/pegasus-artifact-openresty-hello
sudo crictl pull docker.io/pdlan/pegasus-artifact-proxy-caddy-pegasus
sudo crictl pull docker.io/pdlan/pegasus-artifact-proxy-caddy
sudo crictl pull docker.io/pdlan/pegasus-artifact-proxyv2
sudo crictl pull docker.io/pdlan/pegasus-artifact-web-nginx
sudo crictl pull docker.io/pdlan/pegasus-artifact-web-node
sudo crictl pull docker.io/library/redis:6.2.6
sudo crictl pull docker.io/library/memcached:1.6.22
