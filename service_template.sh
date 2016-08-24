#!/bin/bash

# Template parameters
SERVICE_APPNAME=$1
SERVICE_VERSION=$2
SERVICE_DOCKER_IMAGE=$3
SERVICE_NUM_REPLICAS=$4

# Template body
# -------------
cat << EOF
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  labels: 
    app: ${SERVICE_APPNAME}
    version: ${SERVICE_VERSION}
  name: ${SERVICE_APPNAME}
spec:
  replicas: ${SERVICE_NUM_REPLICAS}
  selector:
    matchLabels:
      app: ${SERVICE_APPNAME}
  template:
    metadata:
      labels:
        app: ${SERVICE_APPNAME}
    spec:
      containers:
        - name: ${SERVICE_APPNAME}
          image: ${SERVICE_DOCKER_IMAGE}
          imagePullPolicy: Always
          ports:
            - name: "http-server"
              containerPort: 3000
              protocol: TCP
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: ${SERVICE_APPNAME}
  name: ${SERVICE_APPNAME}
spec:
  type: LoadBalancer
  ports:
    - port: 3000
      targetPort: "http-server"
  selector:
    app: ${SERVICE_APPNAME}
EOF
