# k8s_demos

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/) and [minikube](https://minikube.sigs.k8s.io/docs/start/)

2. Run `minikube start` to start a local k8s cluster and configure `kubectl` to interact with it.

## Pod, Namespace, and LimitRange

Creates a Pod for the Python application in a namespace and apply resource limits

```bash
kubectl apply -f namespace.yaml -f pod.yaml -f limitrange.yml
kubectl get all -n webapps
kubectl describe limits/limitrange
```

## Deployment

- Using CLI:

   ```bash
   # Create deployment for the application
   kubectl create deployment app-deployment --image=sh3b0/app_python

   # Create an external service to make the app accessible from outside.
   kubectl expose deployment app-deployment --type=LoadBalancer --port=8080

   # Show created objects
   kubectl get all
   ```

- Using manifests:

   ```bash
   kubectl apply -f deployment.yaml -f service.yaml
   kubectl get all
   ```

- When deploying on cloud, an external IP for the service will be available. For testing with minikube, run the following command to get a URL for accessing the service.  

   ```bash
   minikube service app-service --url
   ```

- Verify LoadBalancing functionality (Python App)

   ```bash
   watch kubectl exec -it <pod> -- cat /app/db/visits.json
   ab -n 100 http://<URL>:<PORT>/
   ```

- To remove created objects

   ```bash
   kubectl delete service/app-deployment
   kubectl delete deployment.apps/app-service
   ```

## Init Container

- Runs an Alpine container in a Pod with another init container that downloads an example website to `/tmp/example`.

- Both containers in the pod can (and do) mount a named volume (`example-volume`).

- The init container writes the data to the volume, and the main container can read such data.

- Commands used

   ```bash
   kubectl apply -f init-container.yaml
   kubectl exec -it myapp -- ls /tmp/example
   ```
