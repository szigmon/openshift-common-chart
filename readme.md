# OpenShift Onboarding Common Helm Chart

## Introduction

This Helm chart is designed to simplify the process of onboarding development teams to OpenShift. It provides a standardized way to deploy applications with various OpenShift-specific features, reducing the learning curve for teams unfamiliar with OpenShift manifests.

## Prerequisites

- OpenShift 4.6+
- Helm 3.0+
- `oc` command-line tool
- Crunchy PostgreSQL Operator (if using PostgreSQL feature)

## Quick Start

1. Clone the repository:
   ```
   git clone https://github.com/szigmon/common-helm.git
   cd common-helm
   ```

2. Create a minimal `values.yaml` file:
   ```yaml
   applications:
     - name: my-app
       image:
         repository: my-app-image
   ```

3. Install the chart:
   ```
   helm install my-release .
   ```

This will deploy your application with sensible defaults for OpenShift.

## Configuration Options

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Global environment setting | `development` |
| `global.tenantName` | Name of the tenant | `example-tenant` |

### Common Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `common.serviceAccount` | Default service account name | `application-sa` |
| `common.replicaCount` | Default number of replicas | `1` |
| `common.imagePullPolicy` | Default image pull policy | `IfNotPresent` |
| `common.imageRegistry` | Default image registry | `quay.io` |
| `common.imageProject` | Default image project | `your-project` |

### Application Configuration

Each application in the `applications` list can be configured with the following parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `name` | Name of the application | Required |
| `image.repository` | Image repository | Required |
| `image.tag` | Image tag | `latest` |
| `ports` | List of ports to expose | `[{name: http, containerPort: 8080}]` |
| `route.enabled` | Whether to create a route | `false` |
| `route.host` | Custom hostname for the route | `nil` |
| `route.tls` | TLS configuration for the route | Edge termination with redirect |
| `env` | Environment variables | `[]` |
| `resourceProfile` | Resource profile to use | `small` |
| `resources` | Custom resource configuration | `nil` |
| `livenessProbe` | Liveness probe configuration | `nil` |
| `readinessProbe` | Readiness probe configuration | `nil` |
| `podDisruptionBudget` | PDB configuration | `nil` |
| `podAntiAffinity` | Enable pod anti-affinity | `false` |
| `volumeMounts` | Volume mounts configuration | `[]` |
| `volumes` | Volumes configuration | `[]` |
| `priorityClassName` | Priority class name | `nil` |
| `labels` | Additional labels | `{}` |
| `annotations` | Additional annotations | `{}` |

### PostgreSQL Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Enable PostgreSQL deployment | `false` |
| `postgresql.clusterName` | Name of the PostgreSQL cluster | `postgresql` |
| `postgresql.instances` | Number of PostgreSQL instances | `2` |
| `postgresql.postgresVersion` | PostgreSQL version | `"13"` |

### Network Policies

| Parameter | Description | Default |
|-----------|-------------|---------|
| `networkPolicies.enabled` | Enable network policies | `true` |
| `networkPolicies.defaultDeny` | Enable default deny policy | `false` |

### Monitoring

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceMonitor.enabled` | Enable ServiceMonitor for Prometheus | `false` |
| `serviceMonitor.interval` | Scrape interval | `15s` |
| `podMonitor.enabled` | Enable PodMonitor for Prometheus | `false` |
| `podMonitor.interval` | Scrape interval | `15s` |

## Usage Examples

### Basic Application Deployment

```yaml
applications:
  - name: my-app
    image:
      repository: my-app-image
    route:
      enabled: true
```

### Application with Custom Resources and Probes

```yaml
applications:
  - name: custom-app
    image:
      repository: custom-app
      tag: v1.2.3
    resources:
      limits:
        cpu: "1"
        memory: "1Gi"
      requests:
        cpu: "0.5"
        memory: "512Mi"
    livenessProbe:
      httpGet:
        path: /health
        port: http
    readinessProbe:
      httpGet:
        path: /ready
        port: http
```

### Enabling PostgreSQL

```yaml
postgresql:
  enabled: true
  clusterName: my-postgres
  instances: 2
  postgresVersion: "13"
```

## Best Practices

1. Use resource profiles to standardize resource allocation across applications.
2. Enable network policies to secure communication between applications.
3. Configure liveness and readiness probes for better application health monitoring.
4. Use OpenShift Routes for external access to your applications.
5. Leverage ConfigMaps and Secrets for managing application configuration and sensitive data.
6. Enable ServiceMonitor or PodMonitor for Prometheus integration when needed.

## Troubleshooting

1. Check the application logs:
   ```
   oc logs deployment/my-release-app-name
   ```

2. Verify the deployed resources:
   ```
   oc get all,configmap,secret,pvc,networkpolicy -l app.kubernetes.io/instance=my-release
   ```

3. Debug Helm release:
   ```
   helm get manifest my-release
   ```

## Conclusion

This common Helm chart provides a flexible and powerful way to deploy applications on OpenShift. By using this chart, development teams can quickly onboard their applications without deep knowledge of OpenShift-specific manifests. The chart's default options and customization capabilities allow for both simple and complex deployments, catering to a wide range of application requirements.