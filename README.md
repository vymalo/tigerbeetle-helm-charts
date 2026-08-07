# TigerBeetle Helm Chart

This Helm chart is designed to deploy and manage a **TigerBeetle cluster** on Kubernetes. TigerBeetle is a
high-performance, distributed financial accounting database. This chart simplifies the deployment and management of a
fault-tolerant TigerBeetle cluster by packaging all necessary Kubernetes resources into a single, configurable package.

The chart utilizes a `StatefulSet` to manage the TigerBeetle pods, ensuring stable network identifiers and persistent
storage for each node in the cluster, which is crucial for a distributed database.

## Installation and Configuration

> **The old `https://vymalo.github.io/tigerbeetle-helm-charts` Helm repository is retired.** This chart
> moved from the `vymalo` GitHub org to `ADORSYS-GIS`, and GitHub Pages URLs are not redirected after an
> org transfer — that URL now 404s. The chart is no longer published to GitHub Pages at all; it is
> distributed as an **OCI artifact on GHCR** instead. If you (or a script, or a `Chart.yaml` dependency)
> still reference the old `helm repo add` URL, switch to the `oci://` install form below.

The chart relies on the `bjw-s/common` library chart, which is resolved automatically via `helm dependency
update`/`helm install` — no separate repo needs to be added for it.

### Installation Steps

Install the chart directly from GHCR using its OCI reference (replace `<x.y.z>` with the desired chart
version from [Chart.yaml](charts/tigerbeetle/Chart.yaml) or the
[GHCR package page](https://github.com/orgs/ADORSYS-GIS/packages/container/package/charts%2Ftigerbeetle)):

```sh
helm install tigerbeetle oci://ghcr.io/adorsys-gis/charts/tigerbeetle --version <x.y.z>
```

### Configuration

Configuration can be customized by creating a custom `values.yaml` file and passing it during installation, or by using
the `--set` flag.

* **Using a custom values file:**

  ```sh
  helm install tigerbeetle oci://ghcr.io/adorsys-gis/charts/tigerbeetle --version <x.y.z> -f my-custom-values.yaml
  ```

* **Using the `--set` flag:**

  ```sh
  helm install tigerbeetle oci://ghcr.io/adorsys-gis/charts/tigerbeetle --version <x.y.z> --set controllers.main.replicas=5
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