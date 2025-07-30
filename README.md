# Kubernetes MyWebsite - Littlefashion

This repository contains the codebase for deploying the "Littlefashion" web application using both Docker and Kubernetes. This guide covers the setup, usage, and deployment instructions for both environments.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Docker Usage](#docker-usage)
  - [Building the Docker Image](#building-the-docker-image)
  - [Running the Application with Docker](#running-the-application-with-docker)
- [Kubernetes Usage](#kubernetes-usage)
  - [Kubernetes Manifests](#kubernetes-manifests)
  - [Deploying on Kubernetes](#deploying-on-kubernetes)
- [Prerequisites](#prerequisites)
- [Step-by-step Instructions](#step-by-step-instructions)
- [Useful Commands](#useful-commands)

---

## Project Overview

"Littlefashion" is a sample web application designed for demonstration and learning purposes, showcasing how to containerize and orchestrate an application using Docker and Kubernetes.

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

### Running the Application with Docker

3. **Run the Docker container:**
    ```sh
    docker run -d -p 8080:80 --name littlefashion-app littlefashion:latest
    ```
    - The application will be accessible at [http://localhost:8080/mywebsite/(http://localhost:8080/mywebsite/).

---

## Kubernetes Usage

### Kubernetes Manifests

This repository should include Kubernetes manifests (YAML files) for Deployment and Service, such as:

- `deployment.yaml`
- `service.yaml`

### Deploying on Kubernetes

4. **Ensure your Docker image is available to your Kubernetes cluster:**
    - If using Minikube, you can load the image directly:
        ```sh
        minikube image load littlefashion:latest
        ```
    - Otherwise, push your image to a container registry (Docker Hub, GitHub Packages, etc.), and update the image reference in your YAML files.

5. **Apply the Kubernetes manifests:**
    ```sh
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

6. **Expose the service (if needed):**
    - For Minikube:
        ```sh
        minikube service littlefashion-service
        ```
    - For other clusters, use `kubectl get svc` to find the external IP.

---

## Prerequisites

- [Docker](https://www.docker.com/get-started) installed.
- [Kubernetes](https://kubernetes.io/docs/setup/) cluster (Minikube or any managed service).
- [kubectl](https://kubernetes.io/docs/tasks/tools/) CLI tool.

---

## Step-by-step Instructions

### Docker

1. Clone the repository.
2. Build the Docker image.
3. Run the Docker container.

### Kubernetes

1. Clone the repository.
2. Build and load/push the Docker image to a registry accessible by your cluster.
3. Update the image name in the Kubernetes manifests if using a remote registry.
4. Apply the manifests to your cluster.
5. Access the service using the provided URL or IP.

---

## Useful Commands

- **Build Docker image:**  
  `docker build -t littlefashion:latest .`
- **Run Docker container:**  
  `docker run -d -p 8080:80 littlefashion:latest`
- **Load image into Minikube:**  
  `minikube image load littlefashion:latest`
- **Apply Kubernetes manifests:**  
  `kubectl apply -f deployment.yaml -f service.yaml`
- **Check pods/services:**  
  `kubectl get pods`  
  `kubectl get svc`
- **Delete resources:**  
  `kubectl delete -f deployment.yaml -f service.yaml`

---

## Notes

- Ensure your Kubernetes manifests refer to the correct Docker image name (including registry if pushed remotely).
- For production deployments, consider using environment variables, Secrets, and ConfigMaps for configuration.
- Update ports in the manifests and Dockerfile as per your application's requirements.

---

## Contribution

Feel free to open issues or submit pull requests for improvements and bug fixes.

---
