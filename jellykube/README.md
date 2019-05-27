# Jellykube

```sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -

cat /etc/rancher/k3s/k3s.yaml

mkdir -p /root/k8s-volumes/traefik-acme
```

https://github.com/rancher/k3s/issues/117#issuecomment-496291969

https://github.com/rancher/k3s/blob/master/manifests/traefik.yaml
