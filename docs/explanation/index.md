# Explanation

This chart packages the APEx Dispatch API FastAPI service for Kubernetes environments
that use Knative Serving. Its main goal is to make the service easy to deploy,
configure, render, and validate while the application is being developed and tested.

## What The Chart Describes

The chart creates a small set of resources around the application:

- a Knative `Service` to run the FastAPI container
- a `ConfigMap` for non-secret runtime configuration
- an optional `Secret` for sensitive values such as client credentials and backend
  configuration

This keeps the deployment model simple and focused on the needs of a service that is
iterated on frequently.

## Why Knative Serving

The chart uses `serving.knative.dev/v1` `Service` resources instead of a plain
Kubernetes `Deployment` because the target runtime is Knative Serving.

That choice gives the chart a deployment model centered on:

- revision-based updates
- request-driven scaling
- Knative-native autoscaling settings such as `minScale`, `maxScale`, and
  `containerConcurrency`

For this chart, Knative is part of the deployment contract rather than an optional
add-on.

## Configuration Approach

The chart separates configuration by intent:

- non-secret application settings go into a `ConfigMap`
- secret material is read from a Kubernetes `Secret`

This mirrors the FastAPI application's runtime needs while keeping local rendering and
test scenarios straightforward. It also lets teams either create the secret from Helm
values or bind the deployment to an existing secret already managed elsewhere.

## Scope

This chart is currently scoped for development and testing purposes.

In practice, that means it is intended to support activities such as:

- local or shared environment validation
- integration testing of rendered manifests
- early deployment testing on a Knative cluster
- experimenting with runtime values, scaling settings, and secrets wiring

It is not documented as a production-hardened deployment package at this stage.
Production concerns such as stricter operational defaults, stronger rollout
guarantees, platform-specific hardening, and environment policy integration should be
treated as follow-on work.

## Why Probes Are Optional By Default

The chart leaves probes disabled by default because the FastAPI health endpoint checks
dependencies beyond simple process startup. For development and testing environments,
it is often more useful to bring the service up first and then enable readiness and
liveness checks once the backing dependencies are wired correctly.
