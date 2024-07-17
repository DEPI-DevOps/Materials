# app_chart_demo

- Install [helm](https://helm.sh/docs/intro/install/)

- Create chart files and directories manually or use `helm create app-deployment` to add some boilerplate.

- Copy some previously-created YAMLs to `templates` directory, parametrize them and put default values in values.yaml

## Install the chart

```bash
helm upgrade --install app-deployment app-deployment/ --values my_values.yaml
​  
helm list            # To see installed charts  
minikube dashboard   # Opens a web UI for debugging
minikube service app --url # Get service address
```

## **Behind the scenes**

- **For each pod in the StatefulSet, K8s will:**

  - Create a PersistentVolumeClaim from the specified `volumeClaimTemplates`

  - Dynamically provision a PersistentVolume at the following `hostPath` with the same properties as the PVC.

    ```bash
    /tmp/hostpath-provisioner/default/{volumeClaimTemplates.metadata.name}-{pod_name}
    ```

  - Statically bind each PVC with a corresponding PV using `volumeName` in the PVC and `claimRef` in the PV.

  - Add a volume each pod named `{volumeClaimTemplates.metadata.name}` which we already mounted on the pod using `volumeMounts`.

- **Concerns and Notes:**

  - **Security risks:** `hostPath` volumes should be avoided overall because they allow access to the host node which introduces security risks.
  - **No multi-node clusters:** this setup won’t work as expected when deployed on a cluster with multiple nodes, `local` volume types should be used instead of `hostPath` for this purpose.
  - **No persistence guarantees:** `visits.json` for each pod will maintain state between pod restarts, but all data will be lost when the StatefulSet is deleted for any reason.
  - **No consistency guarantees:** each pod will get its copy of the path on host and modify it separately, so accessing `/visits` on the web will give inconsistent results.
  - All the above issues are addressed in production by using a remote storage (outside of k8s cluster) such as `nfs` and managing data consistency in application logic (e.g., using master and slaves DB replicas where master is the only pod with write access).
- 