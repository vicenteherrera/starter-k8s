# Istio labs

## Preparation

You may want to download base Istio files with:
```
curl -L https://istio.io/downloadIstio | sh -
```

Use unzipped istioctl binary from `istio-X.Y.Z/bin` directory, install locally, or use [getmesh](https://github.com/tetratelabs/getmesh#get-started).

## Installation

### Istio
```
istioctl install --profile=demo
```

`demo` profile includes core, istiod, ingress and egress.

### Prometheus, Grafana

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/grafana.yaml
while true; do curl -v http://$GATEWAY_URL/; done

### Kiali

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/kiali.yaml

## Deploy lab files

`lab` exercise files taken from:
https://tetrate-academy.thinkific.com/courses/take/istio-fundamentals/

Files have to be created on default namespace

## Use dashboards

```
istiotcl dashboard kiali
getmesh dashboard grafana
```

