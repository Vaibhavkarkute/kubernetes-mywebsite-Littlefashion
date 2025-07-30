# Kubernetes MyWebsite - Littlefashion

This repository contains everything you need to build, containerize, and deploy the **Littlefashion** web application using both Docker and Kubernetes. This document offers an in-depth guide to each step, from local Docker testing to robust Kubernetes orchestration, with detailed explanations about the services, networking, and best practices.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Docker Usage](#docker-usage)
  - [Building the Docker Image](#building-the-docker-image)
  - [Running the Application with Docker](#running-the-application-with-docker)
- [Kubernetes Usage](#kubernetes-usage)
  - [Kubernetes Manifests](#kubernetes-manifests)
  - [Service Types Explained](#service-types-explained)
  - [Deploying on Kubernetes](#deploying-on-kubernetes)
- [Prerequisites](#prerequisites)
- [Step-by-step Instructions](#step-by-step-instructions)
- [Useful Commands](#useful-commands)
- [Best Practices & Notes](#best-practices--notes)
- [Contribution](#contribution)

---

## Project Overview

**Littlefashion** is a sample web application for demonstrating modern DevOps workflows—containerization with Docker and orchestration with Kubernetes. The project provides hands-on learning for developers and SREs looking to understand application lifecycle management in cloud-native environments.

---

## Architecture

```
                +------------------+
                |  Littlefashion   |
                |   Web App Pod    |
                +--------+---------+
                         |
               (ClusterIP Service)
                         |
                  +------v-------+
                  |  K8s Network |
                  +------^-------+
                         |
                 [ NodePort/LoadBalancer ]
                         |
                 +-------v--------+
                 |   External     |
                 |    Clients     |
                 +----------------+
```

- **Pod**: Runs the containerized Littlefashion app.
- **Service**: An abstraction to expose the app to internal/external traffic.
- **Ingress** (optional): For advanced routing and domain management.

---

## Docker Usage

### Building the Docker Image

1. **Clone the repository:**
    ```sh
    git clone https://github.com/Vaibhavkarkute/kubernetes-mywebsite-Littlefashion.git
    cd kubernetes-mywebsite-Littlefashion
    ```

2. **Build the Docker image:**
    ```sh
    docker build -t littlefashion:latest .
    ```
    - `-t littlefashion:latest` tags the image for easy reference.

### Running the Application with Docker

3. **Run the Docker container:**
    ```sh
    docker run -d -p 8080:80 --name littlefashion-app littlefashion:latest
    ```

    - `-d`: Detached mode (runs in the background)
    - `-p 8080:80`: Maps port 80 inside the container to port 8080 on your host
    - `--name littlefashion-app`: Names the running container

4. **Access the Application:**
    - Open your browser to [http://localhost:8080/mywebsite/](http://localhost:8080/mywebsite/)

---

## Kubernetes Usage

### Kubernetes Manifests

You should find the following YAML files in the repo:

- `deployment.yaml`: Defines the deployment of your application pods.
- `service.yaml`: Exposes your deployment via a Kubernetes Service.

#### Example: `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: littlefashion-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: littlefashion
  template:
    metadata:
      labels:
        app: littlefashion
    spec:
      containers:
      - name: littlefashion
        image: littlefashion:latest
        ports:
        - containerPort: 80
```

#### Example: `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: littlefashion-service
spec:
  type: NodePort
  selector:
    app: littlefashion
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

> **Note:**  
> - `type: NodePort` exposes the app on all nodes at `nodeIP:30080`.  
> - For production, consider using `LoadBalancer` or an Ingress for better traffic management.

---

### Service Types Explained

Kubernetes **Services** expose your pods to traffic. There are several types:

- **ClusterIP** (default): Exposes the service on a cluster-internal IP. Only accessible within the cluster.
- **NodePort**: Exposes the service on each node’s IP at a static port (e.g., 30080). Good for development/testing.
- **LoadBalancer**: Provisions a cloud load balancer and assigns a public IP (used on cloud providers).
- **Ingress**: Manages external access (usually HTTP) to services in the cluster, typically providing SSL and routing.

---

### Deploying on Kubernetes

1. **Load your Docker image into the cluster:**

    - **Minikube:**
        ```sh
        minikube image load littlefashion:latest
        ```
    - **Other clusters:**  
        Push your image to a registry (e.g., Docker Hub), update the image reference in `deployment.yaml` to `your-dockerhub-username/littlefashion:latest`.

2. **Apply the manifests:**
    ```sh
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

3. **Access the service:**
    - **Minikube:**
        ```sh
        minikube service littlefashion-service
        ```
        This command opens a browser window to the app.
    - **Other clusters:**
        - Run `kubectl get svc` and look for the `EXTERNAL-IP` or `NODE-PORT` to access the app.
        - URL will be `http://<node-ip>:<nodePort>/mywebsite/`

---

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Kubernetes](https://kubernetes.io/docs/setup/) (Minikube, Kind, or a managed service)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- (Optional) [Docker Hub](https://hub.docker.com/) or another container registry account

---

## Step-by-step Instructions

### Docker

1. Clone the repository.
2. Build the Docker image (`docker build ...`).
3. Run the container (`docker run ...`).
4. Access the app at [http://localhost:8080/mywebsite/](http://localhost:8080/mywebsite/).

### Kubernetes

1. Clone the repository.
2. Build and load/push the Docker image.
3. Update the image name in `deployment.yaml` if pushing to a remote registry.
4. Apply the Kubernetes manifests.
5. Access the service using Minikube or your cluster's NodePort/LoadBalancer IP.

---

## Useful Commands

- **Build Docker image:**  
  `docker build -t littlefashion:latest .`
- **Run Docker container:**  
  `docker run -d -p 8080:80 littlefashion:latest`
- **Load image into Minikube:**  
  `minikube image load littlefashion:latest`
- **Push to Docker Hub:**  
  `docker tag littlefashion:latest your-dockerhub-username/littlefashion:latest`
  `docker push your-dockerhub-username/littlefashion:latest`
- **Apply Kubernetes manifests:**  
  `kubectl apply -f deployment.yaml -f service.yaml`
- **Check pods/services:**  
  `kubectl get pods`  
  `kubectl get svc`
- **View logs:**  
  `kubectl logs <pod-name>`
- **Delete resources:**  
  `kubectl delete -f deployment.yaml -f service.yaml`

---

## Best Practices & Notes

- **Image Reference:**  
  Ensure your Kubernetes manifests use the correct image name (include registry prefix if needed).

- **Environment Variables:**  
  Use environment variables in your `deployment.yaml` for configuration (see `env:` section in container spec).

- **Secrets/ConfigMaps:**  
  For sensitive data or configuration, use Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) and [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/).

- **Resource Limits:**  
  Specify `resources:` in your pod spec to control CPU/memory usage.

- **Readiness/Liveness Probes:**  
  Add probes to automate health checks and restarts.

- **Ingress (Advanced):**  
  For custom domains and TLS, add an Ingress resource. Example:
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: littlefashion-ingress
    spec:
      rules:
      - host: mywebsite.local
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: littlefashion-service
                port:
                  number: 80
    ```
    - You must install an Ingress controller (e.g., NGINX Ingress) and update your `/etc/hosts` for local development.

---

## Contribution

Contributions are welcome!  
- Open issues for bugs or feature requests.
- Submit pull requests for improvements.

---

**For more advanced Kubernetes scenarios (rolling updates, auto-scaling, custom domains), refer to the [Kubernetes official documentation](https://kubernetes.io/docs/home/).**
