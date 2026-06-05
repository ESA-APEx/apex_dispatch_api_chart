# APEx Dispatch API Knative Helm Chart

This repository contains a Helm chart for deploying the FastAPI-based APEx Dispatch
API on Knative Serving using `serving.knative.dev/v1` `Service` resources.

The chart is intended for development and testing deployments of the APEx Dispatch
API in Knative-enabled Kubernetes environments.

## Repository Layout

- `charts/`: Helm chart sources
- `docs/`: MkDocs documentation organized with the Diataxis structure
- `.github/workflows/`: CI workflows for docs and Helm chart packaging/publishing
- `Taskfile.yaml`: local developer commands

## Chart Location

The Helm chart lives in `charts/`.

## Local Commands

Render the chart locally:

```bash
task helm:render
```

Run the Helm unit tests:

```bash
task helm:test
```

Serve the documentation locally:

```bash
task docs:serve
```

Build the documentation:

```bash
task docs:build
```

## Install

```bash
helm install apex-dispatch-api ./charts
```

## OCI Distribution

The Helm chart is also published as an OCI artifact in GitHub Container Registry:

- Package page: [ghcr.io OCI package](https://github.com/ESA-APEx/apex_dispatch_api_chart/pkgs/container/helm%2Fapex-dispatch-api)
- OCI reference: `oci://ghcr.io/esa-apex/helm/apex-dispatch-api`

Pull the chart from GHCR:

```bash
helm pull oci://ghcr.io/esa-apex/helm/apex-dispatch-api --version 0.1.0
```

Install directly from the OCI registry:

```bash
helm install apex-dispatch-api oci://ghcr.io/esa-apex/helm/apex-dispatch-api --version 0.1.0
```

## Important values

- `serviceAccountName`: Kubernetes service account used by the Knative revision pod
- `image.repository`, `image.tag`: container image to run
- `knative.minScale`, `knative.maxScale`: Knative autoscaling bounds
- `secrets.create`: create the app secret from Helm values or reference an existing one
- `probes.enabled`: enable `/health` probes if your runtime dependencies are ready at startup

See [`docs/reference/index.md`](docs/reference/index.md) for the detailed values and
runtime contract.

## Required secret keys

If `secrets.create=false`, the secret referenced by `secrets.name` should already
exist and contain:

- `KEYCLOAK_CLIENT_ID`
- `KEYCLOAK_CLIENT_SECRET`
- `BACKENDS`

## Documentation

The project documentation is built with MkDocs and includes:

- tutorials
- how-to guides
- explanation pages
- reference material

The documentation entry point is [`docs/index.md`](docs/index.md).

## CI

The repository includes GitHub Actions workflows for:

- building and deploying documentation with a GitHub Pages approach
- packaging the Helm chart
- publishing the Helm chart to `ghcr.io` as an OCI artifact

On `main`, the Helm OCI workflow publishes a `latest` tag alias. On `vX.Y.Z` tags, it
publishes the chart with version `X.Y.Z`.

## License

This project is licensed under the Apache License 2.0. See [`LICENSE`](LICENSE).
