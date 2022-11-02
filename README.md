# k3s_tf

```
$ export AWS_ACCESS_KEY_ID=XXX
$ export AWS_SECRET_ACCESS_KEY=XXX
$ terraform init
$ terraform apply

$ ssh admin@$(terraform output -raw master_public_ip) 'sudo k3s kubectl get node'
NAME               STATUS   ROLES                  AGE   VERSION
ip-172-31-17-10    Ready    control-plane,master   49m   v1.25.3+k3s1
ip-172-31-24-85    Ready    <none>                 49m   v1.25.3+k3s1
ip-172-31-21-163   Ready    <none>                 49m   v1.25.3+k3s1


$ ssh admin@$(terraform output -raw master_public_ip) "sudo k3s kubectl apply -f - " < ./app/arm64.yaml
deployment.apps/nginx-deployment-arm created

$ ssh admin@$(terraform output -raw master_public_ip) "sudo k3s kubectl apply -f - " < ./app/amd64.yaml
deployment.apps/nginx-deployment-amd created

$ ssh admin@$(terraform output -raw master_public_ip) 'sudo k3s kubectl get all'                                 
NAME                                        READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-arm-7ff7f94bd5-9xp7g   1/1     Running   0          2m6s
pod/nginx-deployment-amd-74df87b57-hl8vq    1/1     Running   0          112s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   53m

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment-arm   1/1     1            1           2m6s
deployment.apps/nginx-deployment-amd   1/1     1            1           112s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-arm-7ff7f94bd5   1         1         1       2m6s
replicaset.apps/nginx-deployment-amd-74df87b57    1         1         1       112s

```