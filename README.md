# go-app


A simple static web application written in Go. This repository demonstrates how to build, containerize, and deploy a Go application to Kubernetes using various methods, including raw manifests, Helm, and ArgoCD.

## Features

*   Simple web server built using Go's standard `net/http` library.
*   Serves static HTML pages for Home, About, Courses, and Contact.
*   Containerized using a multi-stage `Dockerfile` for a lightweight and secure image.
*   Includes standard Kubernetes manifests for deployment.
*   Provides a Helm chart for templated and reusable Kubernetes deployments.
*   Includes an ArgoCD Application manifest for GitOps-style continuous deployment.

## Project Structure

```
.
├── Dockerfile                  # For building the container image
├── go.mod                      # Go module definition
├── main.go                     # Main application source code
├── main_test.go                # Basic tests for the HTTP handlers
├── argocd/                     # ArgoCD Application manifest
│   └── file.yaml
├── go-web-app-chart/           # Helm chart for Kubernetes deployment
│   ├── Chart.yaml
│   ├── templates/
│   └── values.yaml
├── k8s/                        # Raw Kubernetes manifests
│   └── manifests/
│       ├── deployment.yaml
│       ├── ingress.yaml
│       └── service.yaml
└── static/                     # Static HTML assets
    ├── about.html
    ├── contact.html
    ├── courses.html
    └── home.html
```

## Getting Started

### Prerequisites

*   [Go](https://golang.org/doc/install) (v1.22+)
*   [Docker](https://docs.docker.com/get-docker/)
*   A Kubernetes cluster (e.g., [Minikube](https://minikube.sigs.k8s.io/docs/start/), [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/))
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   [Helm](https://helm.sh/docs/intro/install/)

### 1. Running Locally

To run the application directly on your local machine:

```bash
go run main.go
```

The application will be available at `http://localhost:8080`.

### 2. Building and Running with Docker

1.  Build the Docker image:

    ```bash
    docker build -t go-web-app:latest .
    ```

2.  Run the container:

    ```bash
    docker run -p 8080:8080 go-web-app:latest
    ```

    The application will be available at `http://localhost:8080`.

### 3. Deploying to Kubernetes

#### Using Raw Manifests

The `k8s/manifests` directory contains the necessary Kubernetes resources.

1.  Apply the manifests:
    ```bash
    kubectl apply -f k8s/manifests/
    ```
2.  Verify the deployment:
    ```bash
    kubectl get deployment,service,ingress
    ```
3.  Access the application. If you are using Minikube with the NGINX Ingress controller, you may need to add an entry to your `/etc/hosts` file:
    ```
    <minikube-ip> go-web-app.local
    ```
    You can then access the app at `http://go-web-app.local`.

#### Using Helm

The `go-web-app-chart` directory contains a Helm chart for the application.

1.  Install the Helm chart:
    ```bash
    helm install go-app ./go-web-app-chart
    ```
2.  To customize the deployment, you can override values. For example, to change the image tag and replica count:
    ```bash
    helm install go-app ./go-web-app-chart \
      --set replicaCount=3 \
      --set image.tag=v2
    ```
3.  Verify the release:
    ```bash
    helm ls
    kubectl get deployment,service,ingress
    ```

#### Using ArgoCD

The `argocd/file.yaml` manifest defines an ArgoCD Application that points to this repository and deploys the Helm chart.

1.  Assuming you have ArgoCD installed in your cluster, apply the application manifest:
    ```bash
    kubectl apply -f argocd/file.yaml
    ```
2.  ArgoCD will automatically sync the repository and deploy the application according to the Helm chart defined in the `source` field.

## API Endpoints

The web server exposes the following endpoints, which serve static HTML pages:

*   `/home`
*   `/about`
*   `/courses`
*   `/contact`

## Testing

To run the tests for the HTTP handlers, execute the following command:

```bash
go test -v
```

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.
