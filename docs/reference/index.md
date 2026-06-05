# Reference

This page is the technical lookup for the APEx Dispatch API Knative Helm chart.

## Chart Overview

- Chart path: `charts/`
- Chart API version: `v2`
- Workload kind: `serving.knative.dev/v1` `Service`
- Main templates:
  - `templates/service.yaml`
  - `templates/configmap.yaml`
  - `templates/secret.yaml`

## Rendered Resources

The chart can render these Kubernetes resources:

- `ConfigMap`
  - Name pattern: `<release>-apex-dispatch-api-config`
  - Purpose: non-secret application configuration
- `Secret`
  - Rendered only when `secrets.create=true`
  - Purpose: secret application configuration
- Knative `Service`
  - API version: `serving.knative.dev/v1`
  - Purpose: deploy the FastAPI container with Knative Serving

## Default Values

### Naming

| Key | Default |
| --- | --- |
| `nameOverride` | `""` |
| `fullnameOverride` | `""` |
| `serviceAccountName` | `dispatch-api-service-account` |

### Image

| Key | Default |
| --- | --- |
| `image.repository` | `apex-dispatch-api` |
| `image.tag` | `latest` |
| `image.pullPolicy` | `IfNotPresent` |
| `image.pullSecrets` | `[]` |

### Service Port

| Key | Default |
| --- | --- |
| `service.port` | `8000` |

### Knative

| Key | Default |
| --- | --- |
| `knative.annotations` | `{}` |
| `knative.labels` | `{}` |
| `knative.minScale` | `0` |
| `knative.maxScale` | `3` |
| `knative.containerConcurrency` | `0` |
| `knative.timeoutSeconds` | `300` |
| `knative.revision.annotations` | `{}` |
| `knative.revision.labels` | `{}` |

### Application Config

| Key | Default |
| --- | --- |
| `app.name` | `APEx Dispatch API` |
| `app.description` | `""` |
| `app.environment` | `development` |
| `app.version` | `development` |
| `app.corsAllowedOrigins` | `*` |

### Keycloak

| Key | Default |
| --- | --- |
| `keycloak.host` | `auth.dev.apex.esa.int` |
| `keycloak.realm` | `apex` |

### Secrets

| Key | Default |
| --- | --- |
| `secrets.create` | `false` |
| `secrets.name` | `apex-dispatch-api-secrets` |
| `secrets.keycloakClientId` | `""` |
| `secrets.keycloakClientSecret` | `""` |
| `secrets.backends` | `""` |

`secrets.keycloakClientId` and `secrets.keycloakClientSecret` are only used when
`secrets.create=true`.

In that mode:

- `secrets.keycloakClientId` becomes the `KEYCLOAK_CLIENT_ID` key in the generated
  Kubernetes `Secret`
- `secrets.keycloakClientSecret` becomes the `KEYCLOAK_CLIENT_SECRET` key in the
  generated Kubernetes `Secret`
- the Knative service injects those secret keys into the FastAPI container as
  `KEYCLOAK_CLIENT_ID` and `KEYCLOAK_CLIENT_SECRET` environment variables

When `secrets.create=false`, the chart does not use those Helm values and instead
expects an existing secret named by `secrets.name`.

### Scheduling and Runtime

| Key | Default |
| --- | --- |
| `resources` | `{}` |
| `nodeSelector` | `{}` |
| `tolerations` | `[]` |
| `affinity` | `{}` |
| `extraEnv` | `[]` |
| `extraEnvFrom` | `[]` |

### Probes

| Key | Default |
| --- | --- |
| `probes.enabled` | `false` |
| `probes.readiness.httpGet.path` | `/health` |
| `probes.readiness.httpGet.port` | `8000` |
| `probes.readiness.initialDelaySeconds` | `5` |
| `probes.readiness.periodSeconds` | `10` |
| `probes.liveness.httpGet.path` | `/health` |
| `probes.liveness.httpGet.port` | `8000` |
| `probes.liveness.initialDelaySeconds` | `10` |
| `probes.liveness.periodSeconds` | `20` |

## Environment Variables

The chart injects application configuration through a mix of `ConfigMap` and `Secret`
references.

### From the ConfigMap

- `APP_NAME`
- `APP_DESCRIPTION`
- `APP_ENV`
- `APP_VERSION`
- `CORS_ALLOWED_ORIGINS`
- `KEYCLOAK_HOST`
- `KEYCLOAK_REALM`

### From the Secret

- `KEYCLOAK_CLIENT_ID`
- `KEYCLOAK_CLIENT_SECRET`
- `BACKENDS`

If `secrets.create=false`, the secret named by `secrets.name` must already exist.

## Secret Contract

When using an existing secret, it must define these keys:

| Secret key | Purpose |
| --- | --- |
| `KEYCLOAK_CLIENT_ID` | OAuth client identifier |
| `KEYCLOAK_CLIENT_SECRET` | OAuth client secret |
| `BACKENDS` | Backend JSON configuration consumed by the FastAPI app |

## Knative Service Behavior

The rendered Knative service includes:

- container port `8000` by default
- Knative autoscaling annotations on the revision template
- optional `imagePullSecrets`
- `serviceAccountName: dispatch-api-service-account` by default
- optional `readinessProbe` and `livenessProbe`
- optional `nodeSelector`, `affinity`, and `tolerations`
- optional extra environment variables and `envFrom` entries

## Repository Tasks

The current [`Taskfile.yaml`](/data/work/github/apex/apex_dispatch_api_chart/Taskfile.yaml:1)
defines these tasks:

| Task | Purpose |
| --- | --- |
| `task helm:render` | Render the chart into `dist/rendered.yaml` |
| `task helm:test` | Run Helm unit tests with `helm-unittest` |
| `task docs:serve` | Start the MkDocs development server |

## Test Suites

Helm unit tests live under `charts/tests/` and currently cover:

- config map rendering
- secret rendering
- Knative service defaults and overrides
