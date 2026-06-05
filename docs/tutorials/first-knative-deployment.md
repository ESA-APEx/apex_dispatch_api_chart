# First Knative Deployment

This tutorial walks through a first deployment flow for the APEx Dispatch API Helm
chart. By the end, you will have rendered the manifests, reviewed the key settings,
and installed the chart into a Knative-enabled Kubernetes cluster.

## Before You Start

You need:

- `helm`
- `task`
- access to a Kubernetes cluster with Knative Serving installed
- a container image for the APEx Dispatch API
- a Kubernetes secret containing the application credentials and backend settings

In this tutorial, we will use:

- release name: `apex-dispatch-api`
- namespace: `default`
- chart path: `./charts`
- values override file: `tutorial-values.yaml`

## Step 1: Review the chart structure

From the repository root, inspect the main chart files:

```bash
find charts -maxdepth 2 -type f | sort
```

You should see templates for:

- the Knative `Service`
- the `ConfigMap`
- the optional `Secret`
- Helm unit tests under `charts/tests`

## Step 2: Create a values override file

Create a file named `tutorial-values.yaml` with the following contents:

```yaml
image:
  repository: registry.example.org/apex-dispatch-api
  tag: 0.7.2

knative:
  minScale: 1
  maxScale: 2

app:
  environment: development
  corsAllowedOrigins: "*"

secrets:
  create: false
  name: apex-dispatch-api-secrets
```

This tells the chart which image to run and which existing secret to reference.

## Step 3: Check that the secret exists

The chart expects the referenced secret to contain:

- `KEYCLOAK_CLIENT_ID`
- `KEYCLOAK_CLIENT_SECRET`
- `BACKENDS`

Verify it with:

```bash
kubectl get secret apex-dispatch-api-secrets
```

If the secret does not exist yet, create it before continuing.

## Step 4: Render the manifests locally

Render the chart with:

```bash
helm template apex-dispatch-api ./charts -f tutorial-values.yaml
```

Or use the repository task:

```bash
task helm:render
```

During review, look for:

- the Knative `Service` resource
- the configured container image
- the `minScale` and `maxScale` annotations
- the secret name under the container environment references

## Step 5: Run the chart tests

Run:

```bash
task helm:test
```

This confirms that the chart templates still satisfy the current Helm unit tests
before you install anything.

## Step 6: Install the chart

Install the release with:

```bash
helm upgrade --install apex-dispatch-api ./charts -f tutorial-values.yaml
```

This creates the Knative service and supporting resources in the current Kubernetes
context.

## Step 7: Verify the deployment

Check that the Knative service exists:

```bash
kubectl get ksvc apex-dispatch-api
```

Then inspect the rendered URL and readiness:

```bash
kubectl describe ksvc apex-dispatch-api
```

At this point, you should be able to confirm that:

- the service revision was created
- the image is the one you configured
- the service is using the expected secret and config map

## What You Learned

You have now completed a basic deployment flow for the chart:

- prepared override values
- verified the secret contract
- rendered the chart locally
- ran Helm unit tests
- installed the chart into Knative

From here, a good next step is to continue with the how-to guides for custom images,
probes, and secret reuse.
