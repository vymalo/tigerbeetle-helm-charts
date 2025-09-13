# TigerBeetle Helm Chart

This Helm chart is designed to deploy and manage a **TigerBeetle cluster** on Kubernetes. TigerBeetle is a
high-performance, distributed financial accounting database. This chart simplifies the deployment and management of a
fault-tolerant TigerBeetle cluster by packaging all necessary Kubernetes resources into a single, configurable package.

The chart utilizes a `StatefulSet` to manage the TigerBeetle pods, ensuring stable network identifiers and persistent
storage for each node in the cluster, which is crucial for a distributed database.

## Installation and Configuration

The chart relies on the `bjw-s/common` library chart, which must be available in your local Helm repository cache.

### Installation Steps

1. **Add the dependency repository:** Before installing, add the repository containing the `common` chart dependency.

   ```sh
   helm repo add bjw-s-labs https://bjw-s-labs.github.io/helm-charts
   ```

2. **Install the chart:** Install the chart from the local path using the `helm install` command.

   ```sh
   # Navigate to the root of the tigerbeetle-helm project
   helm install my-tigerbeetle-release ./charts/tigerbeetle
   ```

### Configuration

Configuration can be customized by creating a custom `values.yaml` file and passing it during installation, or by using
the `--set` flag.

* **Using a custom values file:**

  ```sh
  helm install my-tigerbeetle-release ./charts/tigerbeetle -f my-custom-values.yaml
  ```

* **Using the `--set` flag:**

  ```sh
  helm install my-tigerbeetle-release ./charts/tigerbeetle --set controllers.main.replicas=5
  ```

## Important Configuration Options

The configuration is managed through the [`values.yaml`](charts/tigerbeetle/values.yaml) file. Here are some of the key
options:

* **Cluster Size (`controllers.main.replicas`)**:
    * Defines the number of TigerBeetle nodes in the cluster.
    * Default: `3`
    * This is a critical setting for establishing the cluster's fault tolerance.

* **Docker Image (`controllers.main.containers.main.image`)**:
    * `repository`: The container image repository. Default: `ghcr.io/tigerbeetle/tigerbeetle`.
    * `tag`: The version of TigerBeetle to deploy. Default: `"0.16.57"`.
    * `pullPolicy`: The image pull policy. Default: `IfNotPresent`.

* **Persistent Storage (`controllers.main.statefulset.volumeClaimTemplates`)**:
    * This section defines the persistent storage for each TigerBeetle replica.
    * `size`: The size of the persistent volume for each replica. Default: `1Gi`.
    * `storageClass`: The name of the `StorageClass` to use for provisioning the volume. If left empty (`""`), the
      default `StorageClass` of the Kubernetes cluster will be used.

* **Service Configuration (`service.main`)**:
    * `type`: The type of Kubernetes service to create. Default: `ClusterIP`, which exposes the service only within the
      cluster. You might change this to `NodePort` or `LoadBalancer` for external access, depending on your
      requirements.
    * `ports.http.port`: The port on which the service is exposed. Default: `3001`.