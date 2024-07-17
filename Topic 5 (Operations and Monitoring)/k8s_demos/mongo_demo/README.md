# k8s_mongo_demo

Deploys MongoDB with Mongo-Express Web UI in K8s. Utilizes ConfigMaps, Secrets, and Ingress.

## Apply

```bash
kubectl apply -f mongo-secret.yaml
kubectl apply -f mongo.yaml
kubectl apply -f mongo-configmap.yaml 
kubectl apply -f mongo-express.yaml
```

## Observe

```bash
kubectl get pod [-w][-o wide][-o yaml]
kubectl get service
kubectl get secret
kubectl get all | grep mongodb
```

## Debug

```bash
kubectl describe pod mongodb-deployment-xxxxxx
kubectl describe service mongodb-service
kubectl logs mongo-express-xxxxxx
```

## Get external URL in MiniKube

```bash
minikube service --url mongo-express-service
```
