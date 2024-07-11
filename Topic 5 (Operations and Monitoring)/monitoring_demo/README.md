# monitoring_demo

## Running App with Monitoring Stack Locally

```bash
docker compose up
```

## Running with Helm

- Install `kube-prometheus-stack` chart

  ```bash
  # Add prometheus-community repo to helm
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

  # Update chart index
  helm repo update

  # Install kube-prometheus-stack in the monitoring namespace.
  # Creating the namespace if required
  helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
  ```

- Default components deployed by the chart

  - **Prometheus**: the monitoring system scraping metrics from other components. The chart also deploys external related components:
    - **AlertManager**: system to send alerts based on certain rules (e.g., a scraped value for a certain metric exceeded a certain threshold).
    - **NodeExporter**: a daemonset running on all nodes and exporting a `/metrics` endpoint for scraping by Prometheus.
    - **Kube-state-metrics**: exports metrics about kubernetes itself.
  - **Prometheus Operator**: k8s integration/plugin for Protmetheus, allows deploying custom resources (notably, `ServiceMonitor`, `PodMonitor`, and `PrometheusRule`) through CRDs.
  - **Grafana**: the visualization web app with pre-created dashboards showing the metrics collected by Prometheus.

- Default resources created by the chart

  ```bash
  # Some of the resources deployed by the chart
  $ kubectl get deployment,svc,sts,ds
  deployment.apps/monitoring-grafana
  deployment.apps/monitoring-kube-prometheus-operator
  deployment.apps/monitoring-kube-state-metrics
  service/alertmanager-operated
  service/monitoring-grafana
  service/monitoring-kube-prometheus-alertmanager
  service/monitoring-kube-prometheus-operator
  service/monitoring-kube-prometheus-prometheus
  service/monitoring-kube-state-metrics
  service/monitoring-prometheus-node-exporter
  service/prometheus-operated
  daemonset.apps/monitoring-prometheus-node-exporter
  statefulset.apps/alertmanager-monitoring-kube-prometheus-alertmanager
  statefulset.apps/prometheus-monitoring-kube-prometheus-prometheus

  # Other resources (configmaps, secrets, serviceaccount, crds, ...) are not shown
  ```

- **Accessing dashboard**

  - For testing with minkube, metrics plugin should be added

    ```bash
    minikube addons enable metrics-server
    ```

  - `kubectl port-forward svc/monitoring-grafana 80 -n monitoring`

  - Access dashboards at <http://localhost/dashboards>, default creds: `admin:prom-operator`
