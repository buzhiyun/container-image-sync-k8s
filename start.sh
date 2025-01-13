#!/bin/bash


# RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
ARCH="amd64"

sudo curl -L --remote-name-all https://dl.k8s.io/release/${RELEASE}/bin/linux/${ARCH}/kubeadm
sudo chmod +x kubeadm

ls -la

./kubeadm config images list -o text --skip-headers --kubernetes-version ${RELEASE}

k8s_image_list=$(./kubeadm config images list -o text --skip-headers --kubernetes-version ${RELEASE})
# 定义重点镜像的关键词列表
# keywords=("kube-apiserver" "kube-controller-manager" "kube-scheduler" "kube-proxy" "pause" "etcd")


# 遍历镜像列表
for image in $k8s_image_list; do
    # 检查镜像名称是否包含关键词
    # if [[ "$image" == *"$keyword"* ]]; then

    # 拉取镜像
    echo "Pulling image: $image"
    docker pull $image
    new_image=$(echo $image | awk -F'/' '{for(i=2;i<=NF;i++) printf "%s/", $i; print ""}' | sed 's/\/$//')
    echo "Tagging image: $image"
    docker tag $image $new_image
    echo "Pushing image: $new_image"


    # fi
done