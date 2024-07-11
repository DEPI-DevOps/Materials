- Install [helm](https://helm.sh/docs/intro/install/)
    
- Create chart files and directories manually or use `helm create app-deployment` to add some boilerplate.
    
- Copy some previously-created YAMLs to `templates` directory, parametrize them and put default values in values.yaml
    
- **Example use case:** deploy nodejs app for the chart
    ```bash
    helm install --set image=sh3b0/app_nodejs:latest my-chart ./app-deployment  
    ​  
    helm list            # to see installed charts  
    minikube dashboard   # opens a web UI for debugging
    ```