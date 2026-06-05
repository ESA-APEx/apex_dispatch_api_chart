# Render the Chart Locally

Use this procedure to render the Helm templates into plain Kubernetes YAML without
installing the chart.

## Render with the task

Run:

```bash
task helm:render
```

This writes the rendered manifests to:

```text
dist/rendered.yaml
```

## Render with Helm directly

Run:

```bash
helm template apex-dispatch-api ./charts
```

## When to use this

Use local rendering when you want to:

- inspect the generated Knative `Service`
- verify values changes before installation
- attach rendered manifests to reviews or test runs
