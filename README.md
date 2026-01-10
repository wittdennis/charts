# charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/charts-derwitt-dev)](https://artifacthub.io/packages/search?repo=charts-derwitt-dev)

Monorepo where I manage all helm charts that I created over time. For documentation on specific charts look at README files inside the chart directories.

## Installation

To use these charts, first add this repository to Helm:

```sh
helm repo add wittdennis https://charts.derwitt.dev
helm repo update
```

Then, install a chart using:

```sh
helm install <release-name> wittdennis/<chart-name>
```

For example, to install node-red:

```sh
helm install my-node-red wittdennis/node-red
```

## Contributing

Contributions are always welcome! You can submit pull requests for new chart updates at any time. I'll try to work through them as swiftly as possible.
