# Topic 5 (Operations and Monitoring)

> Digital Egypt Pioneers Initiative - DevOps Track

After a software product is released to the end-users, IT Operations teams carry on tasks that are mostly related to the management, support, and maintenance of the product. Monitoring solutions help them do such tasks.

## Theory

### IT Operations

Typical tasks include:

- Server maintenance
- Network monitoring
- Data center operations (physical environment)
- Software patching
- Application deployment
- User account management
- Security monitoring
- Data backup and recovery
- Compliance management
- Troubleshooting user issues
- Providing technical documentation

### DevOps vs. Site Reliability Engineering

- **DevOps:** Focuses on the entire software development lifecycle, aiming to break down silos between development and operations teams. It emphasizes collaboration, automation, and continuous improvement to deliver software faster and more reliably.

- **SRE:** Has a narrower focus on the reliability and scalability of systems in production.  They ensure applications perform well, meet user demands, and recover quickly from failures.

### Monitoring

Multiple areas to monitor and setup notifications or alerts.

- Response times
- Resource utilization
- Error rate
- Uptime/Downtime
- Application logs
- Test coverage
- Server health

## Practice

### Kubernetes

![Components of Kubernetes](https://kubernetes.io/images/docs/components-of-kubernetes.svg)

- Kubernetes is a system for automating software deployment, scaling, and management.
- A typical use case involves the deployment of different **[objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)** (expressed as YAML files describing the desired object **spec**ification) on **nodes** (virtual or physical machines) inside the **cluster** that is **controlled** and **managed** by the **master node** which stores information about the cluster state in **etcd** database and exposes an **API** that can be interacted with from the command-line using `kubectl`.

#### Common API Resources

- Common object **kind**s (check `kubectl api-resources`)

  | Object                                                       | Overview                                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | [**Pod**](https://kubernetes.io/docs/concepts/workloads/pods/) | Represents a logical host that typically runs one containerized application, but may run additional **[sidecar](https://kubernetes.io/docs/concepts/workloads/pods/#workload-resources-for-managing-pods)** containers. |
  | [**ReplicaSet**](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) | Ensures that a specified number of pod replicas are running at one time. |
  | [**Deployment**](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Represents an application running in the cluster, provides declarative updates for Pods and ReplicaSets. |
  | [**Service**](https://kubernetes.io/docs/concepts/services-networking/service/) | Represents a network service that makes a set of pods accessible using a single DNS name and can load-balance between them. |
  | [**ConfigMap**](https://kubernetes.io/docs/concepts/configuration/configmap/) | An API object used to store non-confidential  data as key-value pairs that are accessible by pods (e.g., as environment variables). |
  | [**Secret**](https://kubernetes.io/docs/concepts/configuration/secret/) | Similar to ConfigMaps, but are specifically intended to hold confidential data (e.g., passwords and tokens). |
  | [**Ingress**](https://kubernetes.io/docs/concepts/services-networking/ingress/) | An API object that manages external access to the services in a cluster, typically HTTP. |
  | **[StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)** | A deployment for stateful applications; provides guarantees about the ordering and uniqueness of deployed Pods. |
  | **[DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)** | DaemonSet ensures that a copy of a certain pod (e.g., logs collector, metrics exporter, etc) is available on every node in the cluster. |
  | **[PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)** | Abstraction of a persistent storage that can use a local or remote (cloud) storage as a backend. Pods can acquire portions of that storage using a PersistentVolumeClaim |
  | **[LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)** | Enforces minimum and maximum resource usage limits per pod or container in a namespace. |

#### Helm

- **A package manager for k8s:** allows packaging and reusing an existing k8s architecture/manifest as a bundle of YAML files called an **Application Chart** and upload it to a public/private registry (e.g., [ArtifactHub](https://artifacthub.io/)).

  - **Library charts** on the other hand are not meant for deployment, they are typically included as dependencies to other charts to allow reusing snippets of code across charts and avoid duplication.

- **A templating engine:** the packaged YAML files can use the [Helm templating language](https://helm.sh/docs/chart_template_guide/) that can generate different k8s manifests from the same source file through [values files](https://helm.sh/docs/chart_template_guide/values_files/).  

- **Basic Directory structure of a helm chart:**

  ```bash
  mychart/
    templates/   # YAML bundle (where .Values object is accissble)
    charts/      # Chart dependencies
    Chart.yaml   # Chart metadata: name, version, dependencies, etc.
    values.yaml  # Default values for the template files
  ```

### Monitoring

![img](https://prometheus.io/assets/architecture.png)

#### Prometheus

- A monitoring system that pulls (retrieves) **metrics** data (entries of [types](https://prometheus.io/docs/concepts/metric_types/) **counter**, **gauge**, **histogram**, and **summary**) by running a **job** against one or more **instances** and stores these data in a **time-series** database.
- **[Client libraries](https://prometheus.io/docs/instrumenting/clientlibs/)** written in different programming languages can be used to export application metrics while [**exporters**](https://prometheus.io/docs/instrumenting/exporters/) export metrics data from different systems (e.g., a Linux server or a database).
- Metrics database can be queried (using **PromQL**) manually through the web UI or automatically by a visualization and analytics system (e.g., Grafana) or used to configure **alerting rules** that are handled by the **alert manager**.

#### Grafana

- A web application used mainly for visualization and analytics. Once deployed (e.g., as a docker image), it provides a nice UI for creating and customizing **dashboards** with **panels** (containing **graphs**, **bars**, **gauges**, **charts**, etc.) to visualize **metrics** or **logs** collected by a **monitoring** solution (e.g., **Prometheus** or **Grafana Loki**) from different systems or databases.
- It can be used to configure **alerts** and has a **[plugin](https://grafana.com/grafana/plugins/)** system to extend its functionality and integrate with other tools.

#### Grafana Loki

- A monitoring solution like Prometheus, but focused on application **logs** (collected by **[clients](https://grafana.com/docs/loki/latest/clients/)**) instead of general metrics.
- Logs are stored as compressed objects and indexed for high efficiency, they can be queried using **LogQL**.

#### Best Practices

- Official guides: [Grafana](https://grafana.com/docs/grafana/latest/best-practices/), [Loki](https://grafana.com/docs/loki/latest/best-practices/), [Prometheus](https://prometheus.io/docs/practices/).
- Create descriptive logs that follow a common format.
- Implement log rotation to save memory and disk space.
- Create simple, easy to interpret dashboards with meaningful names.
- When configuring alerts, try to have them triggered only when attention is needed.
- Avoid unnecessary dashboard reloading to reduce network load.
- Metric names for Prometheus should have a (single-word) application prefix relevant to the domain the metric belongs to.

## Task

- Write K8s manifests to deploy your application in Minikube (deployment, service, namespace, ingress, roles).
- Deploy monitoring and visualization stack with Prometheus and Grafana for your application in K8s.
- Create a helm chart from the previously-created manifests.
- [Extra] Install your chart against an EKS cluster provisioned from Terraform.

## Resources

- DevOps vs SRE: <https://www.youtube.com/watch?v=OnK4IKgLl24>
- Kubernetes Crash Course: <https://www.youtube.com/watch?v=s_o8dwzRlu4>
- Kubernetes Demos: <https://www.youtube.com/playlist?list=PLy7NrYWoggjy3urR5g7BLJiNjLtQcVckT>
- Prometheus Monitoring: <https://www.youtube.com/playlist?list=PLy7NrYWoggjxCF3av5JKwyG7FFF9eLeL4>
