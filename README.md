# charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/charts-derwitt-dev)](https://artifacthub.io/packages/search?repo=charts-derwitt-dev)

Monorepo where I manage all helm charts that I created over time. For documentation on specific charts look at README files inside the chart directories.

## Installation

Every chart is published both to the classic Helm repository and as an OCI artifact. Use whichever
fits your tooling.

### OCI registry

```sh
helm install <release-name> oci://ghcr.io/wittdennis/helm-charts/<chart-name> --version <version>
```

For example, to install node-red:

```sh
helm install my-node-red oci://ghcr.io/wittdennis/helm-charts/node-red --version 2.0.3
```

### Helm repository

```sh
helm repo add wittdennis https://charts.derwitt.dev
helm repo update
helm install <release-name> wittdennis/<chart-name>
```

## Contributing

Contributions are always welcome! You can submit pull requests for new chart updates at any time. I'll try to work through them as swiftly as possible.
