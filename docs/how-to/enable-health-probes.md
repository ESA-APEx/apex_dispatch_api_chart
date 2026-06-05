# Enable Health Probes

Use this procedure to enable Kubernetes health probes for the FastAPI container.

## Why probes are disabled by default

The `/health` endpoint may depend on backing services such as the database. In
development and testing environments, you may want to enable probes only after those
dependencies are available.

## Enable the probes

Set:

```yaml
probes:
  enabled: true
  readiness:
    httpGet:
      path: /health
      port: 8000
    initialDelaySeconds: 5
    periodSeconds: 10
  liveness:
    httpGet:
      path: /health
      port: 8000
    initialDelaySeconds: 10
    periodSeconds: 20
```

Then apply the change with:

```bash
helm upgrade --install apex-dispatch-api ./charts -f my-values.yaml
```

## Adjust the port if needed

If you change `service.port`, update the probe port to match the container port used by
the chart.
