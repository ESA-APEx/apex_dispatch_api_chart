# Reuse an Existing Kubernetes Secret

Use this procedure when the application secret is already managed outside Helm.

## Required secret keys

The secret must contain:

- `KEYCLOAK_CLIENT_ID`
- `KEYCLOAK_CLIENT_SECRET`
- `BACKENDS`

## Configure the chart

Set `secrets.create` to `false` and point `secrets.name` to the existing secret:

```yaml
secrets:
  create: false
  name: apex-dispatch-api-secrets
```

Install or upgrade with:

```bash
helm upgrade --install apex-dispatch-api ./charts -f my-values.yaml
```

## Notes

- When `secrets.create=false`, the chart does not create a `Secret` resource.
- The Knative service still references the secret by name at runtime.
- Missing keys will surface as application startup or runtime configuration issues.
