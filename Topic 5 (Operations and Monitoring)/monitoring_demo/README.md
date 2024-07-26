# monitoring_demo

## Running App with Monitoring Stack Locally

### Goals

- Prepare a monitoring and visualization environment for the app as a network of containers (application + Grafana + Prometheus + Loki with Promtail client).
- Configure Loki to monitor logs from all running containers and Prometheus to monitor metrics of itself, Loki, and the application.
- Create a Grafana dashboard to visualize the scraped data.

### Logging

- Make sure the application generates logs that can be accessed when running the container.
- (Optional) write code to generate application-specific logs:
  - **Python App:** Flask provides `Flask.Logger` which is a standard [`logging`.Logger](https://docs.python.org/3/library/logging.html#logging.Logger)  
  - **NodeJS App:** `console` utilities for `debug`, `warn`, and `error` can be used.
    - 3rd party libraries such as [Winston](https://www.npmjs.com/package/winston) are commonly used for better logging.
    - ExpressJS also provides [morgan](https://expressjs.com/en/resources/middleware/morgan.html) middleware for logging requests.

### Exporting Metrics

- An HTTP endpoint for application metrics need to be exposed by the application for scraping by Prometheus.
- We can define our own metrics and export them using [client libraries for Python and NodeJS](https://prometheus.io/docs/instrumenting/clientlibs/), or use 3rd party exporters like [prometheus-flask-exporter](https://github.com/rycus86/prometheus_flask_exporter) for Python app and [swagger-stats](https://github.com/slanatech/swagger-stats) for NodeJS app.

### Preparing Environment

- Write a docker-compose.yml for deploying the application with the logging and monitoring stack in a single network [[ref.](https://github.com/grafana/loki/blob/main/production/docker-compose.yaml)].
- Write configuration files for Loki [[ref.](https://grafana.com/docs/loki/latest/configuration/examples/)], Promtail [[ref.](https://grafana.com/docs/loki/latest/clients/promtail/configuration/)], and Prometheus [[ref.](https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus.yml)] and copy them to containers or use a volume.
  - **Loki configuration** specifies internal settings for Loki server and where to store logs (locally or remotely).
  - **Promtail configuration** contains information on the Promtail server, where positions are stored, and how to scrape logs from files.
  - **Prometheus configuration** defines target endpoints to scrape and how often to scrape them.
- Run the 3 containers with a `command` that specifies config file location.

### Demo

- Run `docker compose up` and verify that all containers are running.

- Verify the application is running at <http://localhost:8080>

- Verify Prometheus UI is accessible at <http://localhost:9090> and all targets are up in status tab, you can also run queries with autocompletion.

- Verify Grafana UI is accessible at <http://localhost:3000>

  - Default credentials: `admin:admin`

### Datasources

- Grafana comes with built-in support for many data sources: <https://grafana.com/docs/grafana/latest/datasources/>
- You can configure datasources manually from the UI:
  - Configuration &rarr; Data source &rarr; Add data source
    - &rarr; Loki &rarr; URL = `http://loki:3100` &rarr; Save and test.
    - &rarr; Prometheus &rarr; URL = `http://prometheus:9090` &rarr; Save and test.
  - You can explore a datasource and run LogQL/PromQL queries and see their results in dashboards.
    - Verify that container logs were scraped successfully.
    - Example query that shows application logs `{tag="app"}`
    - Example query showing application endpoint responses: `sum by(status) (flask_http_request_total)`
- Or provision them using a YAML file:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus-datasource
    type: prometheus
    access: proxy
    url: http://prometheus:9090

  - name: Loki
    uid: loki-datasource
    type: loki
    access: proxy
    url: http://loki:3100
```

### Dashboards

- Now we can create interesting dashboards from data collected by Prometheus and Loki and export them as reusable JSON.

- We can also import ready-to-use dashboards for monitoring [loki](https://grafana.com/grafana/dashboards/13407) and [prometheus](https://grafana.com/grafana/dashboards/3662)

  - Dashboards &rarr; New &rarr; Import &rarr; Upload JSON File.

- **Application dashboard created from Grafana UI.**

  - Left panel has type `Logs` and uses Loki data source with query: `{tag="app"}`
  - Right panel has type `Pie Chart` and uses Prometheus data source with query `sum by(status) (flask_http_request_total)` exported by `prometheus-flask-exporter` for the Python app.
  - Dashboard can be exported from settings &rarr; Save Dashboard

  ![monitoring-4](https://i.imgur.com/UO0keI8.png)

- **Dashboards for Prometheus and Loki**

  - Note that metrics names or Grafana dashboard types may change over time, rendering panels with no data. Queries need to be modified accordingly to reflect latest changes. Make sure to use recent and maintained dashboards.

    ![prom-dashboard](https://i.imgur.com/NjVZjOL.png)

    ![loki-dashboard](https://i.imgur.com/AQQ16DP.png)



## Running monitoring stack with Helm

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
  - **Prometheus Operator**: k8s integration/plugin for Prometheus, allows deploying custom resources (notably, `ServiceMonitor`, `PodMonitor`, and `PrometheusRule`) through CRDs.
  - **Grafana**: the visualization web app with pre-created dashboards showing the metrics collected by Prometheus.

- Default resources created by the chart

  ```bash
  # Some of the resources deployed by the chart
  $ kubectl get deployment,svc,sts,ds -n monitoring
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

  - `kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring`

  - Access dashboards at <http://localhost:3000/dashboards>, default creds: `admin:prom-operator`
