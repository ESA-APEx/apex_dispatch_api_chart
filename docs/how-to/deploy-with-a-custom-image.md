# Deploy with a Custom Image

Use this procedure to deploy the chart with a specific container image.

## Override the image at install time

Run:

```bash
helm install apex-dispatch-api ./charts \
  --set image.repository=registry.example.org/apex-dispatch-api \
  --set image.tag=2.0.0
```

## Override the image in a values file

Create a values override file with:

```yaml
image:
  repository: registry.example.org/apex-dispatch-api
  tag: 2.0.0
  pullPolicy: IfNotPresent
```

Then install or upgrade with:

```bash
helm upgrade --install apex-dispatch-api ./charts -f my-values.yaml
```

## Add image pull secrets

If the registry requires authentication, add:

```yaml
image:
  pullSecrets:
    - name: regcred
```

The chart passes these values to the Knative service template as
`spec.template.spec.imagePullSecrets`.
