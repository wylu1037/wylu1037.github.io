---
title: Istio Guides
date: 2022-06-17 22:55:07
tags:
	- Istio
categories:
	- Service Mesh
cover: https://miro.medium.com/max/800/0*ivVkWBfVrkSBI7zs
feature: true
---

[官方文档](https://istio.io/latest/docs/)

# I.









---



# II.Install





---

#   III.Use

服务调用关系





1.设置Gateway

istio-ingressgateway

```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app":"istio-ingressgateway","install.operator.istio.io/owning-resource":"unknown","install.operator.istio.io/owning-resource-namespace":"istio-system","istio":"ingressgateway","istio.io/rev":"default","operator.istio.io/component":"IngressGateways","operator.istio.io/managed":"Reconcile","operator.istio.io/version":"1.14.1","release":"istio"},"name":"istio-ingressgateway","namespace":"istio-system"},"spec":{"ports":[{"name":"status-port","port":15021,"protocol":"TCP","targetPort":15021},{"name":"http2","port":80,"protocol":"TCP","targetPort":8080},{"name":"https","port":443,"protocol":"TCP","targetPort":8443},{"name":"tcp","port":31400,"protocol":"TCP","targetPort":31400},{"name":"tls","port":15443,"protocol":"TCP","targetPort":15443}],"selector":{"app":"istio-ingressgateway","istio":"ingressgateway"},"type":"LoadBalancer"}}
  creationTimestamp: "2022-06-15T15:05:57Z"
  labels:
    app: istio-ingressgateway
    install.operator.istio.io/owning-resource: unknown
    install.operator.istio.io/owning-resource-namespace: istio-system
    istio: ingressgateway
    istio.io/rev: default
    operator.istio.io/component: IngressGateways
    operator.istio.io/managed: Reconcile
    operator.istio.io/version: 1.14.1
    release: istio
  name: istio-ingressgateway
  namespace: istio-system
  resourceVersion: "2878"
  uid: f8c85644-6918-48ac-9363-7e112088a7a0
spec:
  allocateLoadBalancerNodePorts: true
  clusterIP: 10.107.75.185
  clusterIPs:
  - 10.107.75.185
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: status-port
    nodePort: 32692
    port: 15021
    protocol: TCP
    targetPort: 15021
  - name: http2
    nodePort: 31709
    port: 80
    protocol: TCP
    targetPort: 8080
  - name: https
    nodePort: 30231
    port: 443
    protocol: TCP
    targetPort: 8443
  - name: tcp
    nodePort: 31489
    port: 31400
    protocol: TCP
    targetPort: 31400
  - name: tls
    nodePort: 31222
    port: 15443
    protocol: TCP
    targetPort: 15443
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer: {}
```



bookinfo-gateway

```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"networking.istio.io/v1alpha3","kind":"Gateway","metadata":{"annotations":{},"name":"bookinfo-gateway","namespace":"default"},"spec":{"selector":{"istio":"ingressgateway"},"servers":[{"hosts":["*"],"port":{"name":"http","number":80,"protocol":"HTTP"}}]}}
  creationTimestamp: "2022-06-15T23:21:27Z"
  generation: 1
  name: bookinfo-gateway
  namespace: default
  resourceVersion: "34444"
  uid: 32205666-e62e-4a8b-a980-d13962f267ca
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - '*'
    port:
      name: http
      number: 80
      protocol: HTTP
```





bookinfo

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"networking.istio.io/v1alpha3","kind":"VirtualService","metadata":{"annotations":{},"name":"bookinfo","namespace":"default"},"spec":{"gateways":["bookinfo-gateway"],"hosts":["*"],"http":[{"match":[{"uri":{"exact":"/productpage"}},{"uri":{"prefix":"/static"}},{"uri":{"exact":"/login"}},{"uri":{"exact":"/logout"}},{"uri":{"prefix":"/api/v1/products"}}],"route":[{"destination":{"host":"productpage","port":{"number":9080}}}]}]}}
  creationTimestamp: "2022-06-15T23:21:27Z"
  generation: 1
  name: bookinfo
  namespace: default
  resourceVersion: "34445"
  uid: a4a9ef62-9721-4cab-bd0f-9a717336a88d
spec:
  gateways:
  - bookinfo-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        exact: /productpage
    - uri:
        prefix: /static
    - uri:
        exact: /login
    - uri:
        exact: /logout
    - uri:
        prefix: /api/v1/products
    route:
    - destination:
        host: productpage
        port:
          number: 9080
```





prometheus

