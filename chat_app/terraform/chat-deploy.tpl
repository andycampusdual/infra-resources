apiVersion: apps/v1
kind: Deployment
metadata:
  name: chat-app-agd-deployment
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: chat-app-agd
  template:
    metadata:
      labels:
        app: chat-app-agd
    spec:
      containers:
      - name: chat-app-agd
        image: ${ecr_url} 
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
