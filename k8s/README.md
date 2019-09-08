# Jellykube

```sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -

cat /etc/rancher/k3s/k3s.yaml

mkdir -p /root/k8s-volumes/traefik-acme
```

TODO: deploy metrics-server https://github.com/rancher/k3s/issues/328