---
title: Kubernetes Guides
date: 2022-06-09 12:51:57
tags:
	- kubernetes
categories:
	- DevOps
cover: https://i0.wp.com/softwareengineeringdaily.com/wp-content/uploads/2019/01/Kubernetes_New.png?resize=730%2C389&ssl=1
feature: true
---



# 前言

NodeIP、PodIP、ClusterIP

+ clusterIP: Service的ip地址，是虚拟ip地址
+ podIP: Pod的ip地址，即docker容器的ip地址，是虚拟ip地址
+ nodeIP: node节点的ip地址，是物理网卡的ip地址



nodePort、port、targetPort

+ Port: exposes the Kubernetes service on the specified port within the cluster. Other pods within the cluster can communicate with this server on the specified port. 
+ TargetPort: is the port on which the service will send requests to, that your pod will be listening on. Your application in the container will need to be listening on this port also. 
+ NodePort: exposes a service externally to the cluster by means of the target nodes IP address and the NodePort. NodePort is the default setting if the port field is not specified. 





---

# Kubernetes简介

## 1.集群架构





### 1.1 master

主节点，控制平台，不需要很高性能，不跑任务，通常一个就行了，也可以开多个主节点来提高集群可用度。



### 1.2 worker

工作节点，可以是虚拟机或物理计算机，任务都在这里跑，机器性能需要好点；通常都有很多个，可以不断加机器扩大集群；每个工作节点由主节点管理



## 2.概念

### 2.1 Pod





### 2.2 Kubernetes 组件

+ `kube-apiserver` API 服务器，公开了 Kubernetes API
+ `etcd` 键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库
+ `kube-scheduler` 调度 Pod 到哪个节点运行
+ `kube-controller` 集群控制器
+ `cloud-controller` 与云服务商交互







