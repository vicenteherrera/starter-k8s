# starter-k8s

This repo has files to quickstart a Kubernetes project or experiment with Kubernetes

## Prerequisites

Install Docker, make, minikube, heml & helmfile

### Prerequisites for Windows

1. Install Docker from <https://www.docker.com/products/docker-desktop/>
2. Install choco from <https://chocolatey.org/install#individual>
3. Install scoop from <https://scoop.sh/>

From an elevated Powershell console:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

From an elevated console:

```bash
choco install make
choco install minikube
scoop install helmfile
scoop install helm
```

## Usage

```bash
# Create a cluster in minikube, start it, and deploy several platform charts on it
make

# Create a cluster in minikube
make start

# Create a cluster in EKS
make start CLUSTER_TYPE="eks"

# Deploy Prometheus, Grafana, Alertmanager, Gatekeeper (and custom templates & constraints),
# Falco, Robusta, Vault, cert-manager
make helmfile_sync

# Delete minikube cluster
make delete

# Delete eks cluster
make delete CLUSTER_TYPE="eks"

# Follow Kubernetes audit log
make audit_log

# Open proxy connection to Grafana
make proxy_grafana

# Install microservices demo
make install_demo
```

Check more targets at `makefile`.

## Directories

+ clusters: files to create and configure different cluster types
+ charts: files to deploy and configure several Helm charts
+ exercises: files to run commands to practice different Kubernetes concepts

## Configuration

### Alertmanager (Opsgenie, Mailtrap)

**Alertmanager** takes Prometheus rules firing and sends an alert to a receiver application.

To use **Opsgenie** with Alertmanager, copy `sample.envrc` to `.envrc`, and set your API key and team id in that file. Then load its values into environment before deploying charts, with `source .envrc` or using [direnv](https://direnv.net/).

To use **Mailtrap** as an alternative, edit `./charts/prometheus/am-mailtrap.yaml` with your user and password, and edit `./charts/helmfile-observability`, switch commenting these lines so they look like this:

```
    - ./prometheus/am-mailtrap.yaml
    # - ./prometheus/am-opsgenie.yaml
```

If you don't want to configure any alert receiver, comment both lines, and everything under the `set:` directive of `promstack` chart.

### Robusta

Generate your Robusta configuration and set relevant values on `.envrc` as previously, or comment out the whole robusta chart block on `./charts/helmfile-observability.yaml`
