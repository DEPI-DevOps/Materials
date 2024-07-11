# minikube_demo

## Sample Deployment

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/) and [minikube](https://minikube.sigs.k8s.io/docs/start/)

2. Run `minikube start` to start a local k8s cluster and configure `kubectl` to interact with it.

3. Create a deployment for the Python (or NodeJS) application.

   ```bash
   kubectl create deployment python-app --image=sh3b0/app_python
   ```

4. Create an external service to make the app accessible from outside.

   ```bash
   kubectl expose deployment python-app --type=LoadBalancer --port=8080
   ```

5. Show created objects

   ```bash
   kubectl get all
   ```

6. When deploying on cloud, an external IP for the service will be available. For testing with minikube, run the following command to get a URL for accessing the service.  

   ```bash
   minikube service python-app --url
   ```

7. Verify LoadBalancing functionality

   ```bash
   watch kubectl exec -it <pod> -- cat /app/db/visits.json
   ab -n 100 http://192.168.49.2:32447/
   ```

8. Remove created objects

   ```bash
   kubectl delete service/python-app
   kubectl delete deployment.apps/python-app
   ```

9. Create `deployment.yml` and `service.yml` directory to do the same from configuration files instead of stdin.

10. Apply configuration and check results

    ```bash
    kubectl apply -f deployment.yaml -f service.yaml
    kubectl get all
    ```
