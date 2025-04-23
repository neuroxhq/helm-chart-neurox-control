# Neurox Control Helm Chart

This Helm chart is designed to install Neurox Control, a self-hosted monitoring solution for Kubernetes clusters. It provides a comprehensive set of features to monitor and manage your Kubernetes cluster, including GPU usage, resource utilization, and cost tracking.

## Get started
To get started, follow the instructions on the [Neurox Install page](https://app.neurox.com/install). It will guide you step-by-step to a working deployment on your Kubernetes GPU cluster.

The instructions will install a free, self-hosted deployment of a single, combined Neurox Control + Workload cluster. It will contain both Control plane components as well as Workload management components. It will be fully ready-to-use with ingress, TLS certs configured and available at your Neurox Control Portal subdomain (https://random-words.goneurox.com).

## Install process
The installation process will:
- provision a subdomain (random-words.goneurox.com) to access your Control Portal
- provision image registry credentials
- help you to configure an IdP to authenticate your users
- automatically request TLS certificates for your subdomain

Note: Neurox is self-hosted software, so you install and manage it yourself. We only communicate with our servers during install and for support and billing purposes. We will not have remote access to your deployment or any workload data on it.

The install process is primarily designed to help simplify manual creation of DNS records and requesting TLS certificates, typically associated with self-hosted software. Post install, the only data to ever leave your cluster will be to handle support and billing. Airgapped installs are also available to further eliminate all outbound traffic.

Although Neurox is not open-source software, Neurox is free for monitoring up to 64 GPUs, which we believe should fit many use cases, including personal, academic and light commercial use. For more information, see our [pricing plans](https://neurox.com/pricing). We also offer alternative, source-available licensing options for enterprise customers.

## Prerequisites
Prior to installing Neurox, you'll need an existing Kubernetes cluster with at least 1 GPU. Having GPU workloads already running on the cluster helps showcase Neurox's features and capabilities but is not strictly necessary if you just want to poke around. We only support NVIDIA GPUs at this time.

### Cluster requirements
- Kubernetes and CLI 1.29+
- Helm CLI 3.8+
- 12 CPUs
- 24 GB of RAM
- 120 GB Persistent Volume Storage
- At least 1 GPU node
- Ingress reachable from Internet

### Application Prerequisites

At a minimum you will need both cert-manager and ingress-nginx to run the Neurox control chart.

*Cert Manager*
Required for automated provisioning of Neurox SSL/TLS certificates. Install with:
```
helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
helm install --create-namespace -n cert-manager cert-manager jetstack/cert-manager --version v1.17.0 --set crds.enabled=true
```
For more information on how to configure cert-manager: https://cert-manager.io/docs/installation/helm/

*Ingress Nginx*
Required to access the Neurox web portal. Install with:
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install --create-namespace -n ingress-nginx ingress-nginx ingress-nginx/ingress-nginx --version 4.12.1
```
For more information on how to configure ingress-nginx: https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx

For your workload cluster, you will need the NVIDIA GPU operator and Kube Prometheus stack. By default, the install instructions bundle the [Neurox workload helm chart](https://github.com/neuroxhq/helm-chart-neurox-workload) with the Neurox control helm chart. You can change this behavior by simply omitting the `--set workload.enabled=true` parameter in the Neurox control helm chart install command.

*NVIDIA GPU Operator*
Required to run GPU workloads. Install with:
```
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update
helm install --create-namespace -n gpu-operator gpu-operator nvidia/gpu-operator --version=v25.3.0
```
For more information on how to configure NVIDIA GPU operator: https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html#procedure

*Kube Prometheus Stack*
Required to gather metrics. Install with:
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install --create-namespace -n monitoring kube-prometheus-stack prometheus-community/kube-prometheus-stack --set alertmanager.enabled=false --set grafana.enabled=false --set prometheus.enabled=false
```
For more information on how to configure kube-prometheus-stack: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-state-metrics

## Example install

Below is an example of how to install Neurox control plane and workload cluster using Helm:
```
# Replace with actual values
NEUROX_DOMAIN=random-words.goneurox.com
INSTALL_KEY=i_abcdef123456
NEUROX_HELM_REGISTRY=oci://ghcr.io/neuroxhq/helm-charts
NEUROX_IMAGE_REGISTRY=registry.neurox.com
NEUROX_USERNAME=random-words-goneurox-com
NEUROX_PASSWORD=abcdef123456

kubectl create ns neurox
kubectl create secret generic -n neurox neurox-control-license --from-literal=install-key=${INSTALL_KEY}
kubectl create secret docker-registry -n neurox neurox-image-registry --docker-server=${NEUROX_IMAGE_REGISTRY} --docker-username=${NEUROX_USERNAME} --docker-password=${NEUROX_PASSWORD}

helm install neurox-control ${NEUROX_HELM_REGISTRY}/neurox-control --namespace neurox --set global.domain=${NEUROX_DOMAIN} --set workload.enabled=true
```
