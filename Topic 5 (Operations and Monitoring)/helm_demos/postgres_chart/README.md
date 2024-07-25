# postgres_chart_demo

Deploying [bitnami/postgres](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) helm chart in Minikube. Check the chart README and `values.yaml` for the latest state and available options.

## Installing the Chart

- Testing

  ```bash
  helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql
  ```

- CI

  ```shell
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  helm upgrade my-postgres \
  bitnami/postgresql --version 15.5.17 \
  --values values.yaml \
  --namespace postgres --create-namespace --install --cleanup-on-fail --wait
  ```

## Inspect volumes

```bash
kubectl get pv -n postgres
kubectl get pvc -n postgres
kubectl descibe pvc/data-my-postgres-postgresql-0 -n postgres
```

## Removing the Chart

```bash
helm uninstall my-postgres -n postgres
```
