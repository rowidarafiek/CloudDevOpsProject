ivolve Kubernetes Setup

This setup creates a namespace and deploys an application inside it.
You get three files.

Namespace
• Creates a namespace named ivolve
• Use it once before applying other files

Deployment
• Runs two replicas
• Uses the image rowidarafiek/clouddevops-app:1
• Exposes container port 80
• Uses the label app: ivolve

Service
• Connects traffic to the pods using the same label
• Exposes port 80 inside the cluster
• Uses ClusterIP

Steps to apply

kubectl apply -f namespace.yml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
