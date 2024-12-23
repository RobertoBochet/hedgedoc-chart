# HedgeDoc (unofficial) Helm Chart

[![GitHub](https://img.shields.io/github/license/RobertoBochet/hedgedoc-chart?style=flat-square)](https://github.com/RobertoBochet/hedgedoc-chart)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/RobertoBochet/hedgedoc-chart/release.yml?label=publish%20chart&style=flat-square)](https://github.com/RobertoBochet/hedgedoc-chart/releases)
[![GitHub Latest Release Version](https://img.shields.io/github/v/release/RobertoBochet/hedgedoc-chart?sort=semver&display_name=release&style=flat-square)](https://github.com/RobertoBochet/hedgedoc-chart/releases)
[![Static Badge](https://img.shields.io/badge/-hedgedoc-w?style=flat-square&logo=artifacthub&logoColor=white&logoSize=18&label=Artifact%20Hub&labelColor=417598&color=2D4857)](https://artifacthub.io/packages/helm/robertobochet/hedgedoc)

[HedgeDoc](https://hedgedoc.org/) (formerly known as CodiMD) is an open-source, web-based, self-hosted, collaborative markdown editor.

## Deploy

1. Add the repository to helm
   ```shell
   helm repo add robertobochet https://robertobochet.github.io/charts
   helm repo update
   ```
2. Retrieve the default values file
   ```shell
   helm show values robertobochet/hedgedoc > values.yaml
   ```
3. Customize the `values.yaml`
4. Install hedgedoc
   ```shell
   helm install hedgedoc robertobochet/hedgedoc -f values.yaml
   ```

## Parameters

### Global

| Name                      | Description                                                                                       | Value |
| ------------------------- | ------------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`    | global image registry override                                                                    | `""`  |
| `global.imagePullSecrets` | global image pull secrets override; can be extended by `imagePullSecrets`                         | `[]`  |
| `global.storageClass`     | global storage class override                                                                     | `""`  |
| `global.hostAliases`      | global hostAliases which will be added to the pod's hosts files                                   | `[]`  |
| `namespace`               | An explicit namespace to deploy hedgedoc into. Defaults to the release namespace if not specified | `""`  |
| `replicaCount`            | number of replicas for the deployment                                                             | `1`   |

### strategy

| Name                                    | Description    | Value           |
| --------------------------------------- | -------------- | --------------- |
| `strategy.type`                         | strategy type  | `RollingUpdate` |
| `strategy.rollingUpdate.maxSurge`       | maxSurge       | `100%`          |
| `strategy.rollingUpdate.maxUnavailable` | maxUnavailable | `0`             |
| `clusterDomain`                         | cluster domain | `cluster.local` |

### Image

| Name                 | Description                                                                                                            | Value               |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `image.registry`     | image registry, e.g. quay.io,gcr.io,docker.io                                                                          | `quay.io`           |
| `image.repository`   | Image to start for this pod                                                                                            | `hedgedoc/hedgedoc` |
| `image.tag`          | Visit: [Image tag](https://quay.io/repository/hedgedoc/hedgedoc?tab=tags). Defaults to `appVersion` within Chart.yaml. | `""`                |
| `image.variant`      | Image variant, e.g. `alpine`, `debian`                                                                                 | `""`                |
| `image.digest`       | Image digest. Allows to pin the given image tag. Useful for having control over mutable tags like `latest`             | `""`                |
| `image.pullPolicy`   | Image pull policy                                                                                                      | `IfNotPresent`      |
| `image.fullOverride` | Completely overrides the image registry, path/image, tag and digest                                                    | `""`                |
| `imagePullSecrets`   | Secret to use for pulling the image                                                                                    | `[]`                |

### Security

| Name                         | Description                                                     | Value  |
| ---------------------------- | --------------------------------------------------------------- | ------ |
| `podSecurityContext.fsGroup` | Set the shared file system group for all containers in the pod. | `1000` |
| `containerSecurityContext`   | Security context                                                | `{}`   |
| `podDisruptionBudget`        | Pod disruption budget                                           | `{}`   |

### Service

| Name                                    | Description                                                                                                                                                                                          | Value       |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.http.type`                     | Kubernetes service type for web traffic                                                                                                                                                              | `ClusterIP` |
| `service.http.port`                     | Port number for web traffic                                                                                                                                                                          | `3000`      |
| `service.http.clusterIP`                | ClusterIP setting for http autosetup for deployment is None                                                                                                                                          | `None`      |
| `service.http.nodePort`                 | NodePort for http service                                                                                                                                                                            | `""`        |
| `service.http.externalTrafficPolicy`    | If `service.http.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable source IP preservation                                                                                         | `""`        |
| `service.http.externalIPs`              | External IPs for service                                                                                                                                                                             | `[]`        |
| `service.http.ipFamilyPolicy`           | HTTP service dual-stack policy                                                                                                                                                                       | `""`        |
| `service.http.ipFamilies`               | HTTP service dual-stack familiy selection,for dual-stack parameters see official kubernetes [dual-stack concept documentation](https://kubernetes.io/docs/concepts/services-networking/dual-stack/). | `[]`        |
| `service.http.loadBalancerSourceRanges` | Source range filter for http loadbalancer                                                                                                                                                            | `[]`        |
| `service.http.annotations`              | HTTP service annotations                                                                                                                                                                             | `{}`        |
| `service.http.labels`                   | HTTP service additional labels                                                                                                                                                                       | `{}`        |
| `service.http.loadBalancerClass`        | Loadbalancer class                                                                                                                                                                                   | `""`        |

### Ingress

| Name                                 | Description                                                                 | Value                  |
| ------------------------------------ | --------------------------------------------------------------------------- | ---------------------- |
| `ingress.enabled`                    | Enable ingress                                                              | `true`                 |
| `ingress.className`                  | Ingress class name                                                          | `""`                   |
| `ingress.annotations`                | Ingress annotations                                                         | `{}`                   |
| `ingress.hosts[0].host`              | Default Ingress host                                                        | `hedgedoc.example.com` |
| `ingress.hosts[0].paths[0].path`     | Default Ingress path                                                        | `/`                    |
| `ingress.hosts[0].paths[0].pathType` | Ingress path type                                                           | `Prefix`               |
| `ingress.tls`                        | Ingress tls settings                                                        | `[]`                   |
| `ingress.apiVersion`                 | Specify APIVersion of ingress object. Mostly would only be used for argocd. |                        |

### deployment

| Name                                       | Description                                        | Value |
| ------------------------------------------ | -------------------------------------------------- | ----- |
| `resources`                                | Kubernetes resources                               | `{}`  |
| `schedulerName`                            | Use an alternate scheduler, e.g. "stork"           | `""`  |
| `nodeSelector`                             | NodeSelector for the deployment                    | `{}`  |
| `tolerations`                              | Tolerations for the deployment                     | `[]`  |
| `affinity`                                 | Affinity for the deployment                        | `{}`  |
| `topologySpreadConstraints`                | TopologySpreadConstraints for the deployment       | `[]`  |
| `dnsConfig`                                | dnsConfig for the deployment                       | `{}`  |
| `priorityClassName`                        | priorityClassName for the deployment               | `""`  |
| `deployment.terminationGracePeriodSeconds` | How long to wait until forcefully kill the pod     | `60`  |
| `deployment.labels`                        | Labels for the deployment                          | `{}`  |
| `deployment.annotations`                   | Annotations for the Gitea deployment to be created | `{}`  |

### ServiceAccount

| Name                                          | Description                                                                                                                               | Value   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount                                                                                                   | `false` |
| `serviceAccount.name`                         | Name of the created ServiceAccount, defaults to release name. Can also link to an externally provided ServiceAccount that should be used. | `""`    |
| `serviceAccount.automountServiceAccountToken` | Enable/disable auto mounting of the service account token                                                                                 | `false` |
| `serviceAccount.imagePullSecrets`             | Image pull secrets, available to the ServiceAccount                                                                                       | `[]`    |
| `serviceAccount.annotations`                  | Custom annotations for the ServiceAccount                                                                                                 | `{}`    |
| `serviceAccount.labels`                       | Custom labels for the ServiceAccount                                                                                                      | `{}`    |

### Persistence

| Name                                              | Description                                                                                           | Value               |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`                             | Enable persistent storage                                                                             | `true`              |
| `persistence.create`                              | Whether to create the persistentVolumeClaim for shared storage                                        | `true`              |
| `persistence.mount`                               | Whether the persistentVolumeClaim should be mounted (even if not created)                             | `true`              |
| `persistence.claimName`                           | Use an existing claim to store repository information                                                 | `hedgedoc-storage`  |
| `persistence.size`                                | Size for persistence to store repo information                                                        | `10Gi`              |
| `persistence.accessModes`                         | AccessMode for persistence                                                                            | `["ReadWriteOnce"]` |
| `persistence.labels`                              | Labels for the persistence volume claim to be created                                                 | `{}`                |
| `persistence.annotations.helm.sh/resource-policy` | Resource policy for the persistence volume claim                                                      | `keep`              |
| `persistence.storageClass`                        | Name of the storage class to use                                                                      | `""`                |
| `persistence.subPath`                             | Subdirectory of the volume to mount at                                                                | `""`                |
| `persistence.volumeName`                          | Name of persistent volume in PVC                                                                      | `""`                |
| `extraContainers`                                 | Additional sidecar containers to run in the pod                                                       | `[]`                |
| `extraVolumes`                                    | Additional volumes to mount to the Gitea deployment                                                   | `[]`                |
| `extraContainerVolumeMounts`                      | Mounts that are only mapped into the Gitea runtime/main container, to e.g. override custom templates. | `[]`                |

### HedgeDoc

| Name                                           | Description                                                                                                                                                                                                                                                                            | Value        |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `hedgedoc.config`                              | This section will be mapped to HedgeDoc's config.json file. By default, only some basic configurations are present, but it is possible to add any other HedgeDoc configuration options. Visit [HedgeDoc docs](https://docs.hedgedoc.org/configuration/) for all the available options. |              |
| `hedgedoc.config.imageUploadType`              | Where to upload images. Options are: filesystem, imgur, s3, minio, azure, lutim                                                                                                                                                                                                        | `filesystem` |
| `hedgedoc.config.domain`                       | Domain name                                                                                                                                                                                                                                                                            | `""`         |
| `hedgedoc.config.port`                         | Port to listen on                                                                                                                                                                                                                                                                      | `3000`       |
| `hedgedoc.config.protocolUseSSL`               | `true` if you want to serve your instance over SSL (HTTPS), `false` if you want to use plain HTTP. If the ingress uses TLS, it should be set to `true`                                                                                                                                 | `false`      |
| `hedgedoc.config.allowAnonymous`               | Set to allow anonymous usage                                                                                                                                                                                                                                                           | `true`       |
| `hedgedoc.config.allowAnonymousEdits`          | If allowAnonymous is false: allow users to select freely permission, allowing guests to edit existing notes                                                                                                                                                                            | `false`      |
| `hedgedoc.config.allowFreeURL`                 | Set to allow new note creation by accessing a nonexistent note URL. This is the behavior familiar from Etherpad                                                                                                                                                                        | `false`      |
| `hedgedoc.config.requireFreeURLAuthentication` | Set to require authentication for FreeURL mode style note creation                                                                                                                                                                                                                     | `false`      |
| `hedgedoc.config.defaultPermission`            | Set notes default permission (only applied on signed-in users).                                                                                                                                                                                                                        | `editable`   |
| `hedgedoc.config.sessionSecret`                | Cookie session secret used to sign the session cookie. If none is set, one will randomly generated on each startup, meaning all your users will be logged out. Can be generated with e.g. pwgen -s 64 1                                                                                | `changeme`   |
| `hedgedoc.config.email`                        | Set to allow email sign-in                                                                                                                                                                                                                                                             | `true`       |
| `hedgedoc.config.allowEmailRegister`           | Set to allow registration of new accounts using an email address. If set to false, you can still create accounts using the command line. This setting has no effect if hedgedoc.config.email is false                                                                                  | `true`       |
| `hedgedoc.additionalConfigSources`             | Additional configuration from secret or configmap                                                                                                                                                                                                                                      | `[]`         |
| `hedgedoc.additionalConfigFromEnvs`            | Additional configuration sources from environment variables                                                                                                                                                                                                                            | `[]`         |
| `hedgedoc.podAnnotations`                      | Annotations for the Gitea pod                                                                                                                                                                                                                                                          | `{}`         |

### LivenessProbe

| Name                                         | Description                                      | Value  |
| -------------------------------------------- | ------------------------------------------------ | ------ |
| `hedgedoc.livenessProbe.enabled`             | Enable liveness probe                            | `true` |
| `hedgedoc.livenessProbe.initialDelaySeconds` | Initial delay before liveness probe is initiated | `200`  |
| `hedgedoc.livenessProbe.timeoutSeconds`      | Timeout for liveness probe                       | `1`    |
| `hedgedoc.livenessProbe.periodSeconds`       | Period for liveness probe                        | `10`   |
| `hedgedoc.livenessProbe.successThreshold`    | Success threshold for liveness probe             | `1`    |
| `hedgedoc.livenessProbe.failureThreshold`    | Failure threshold for liveness probe             | `10`   |

### ReadinessProbe

| Name                                          | Description                                       | Value  |
| --------------------------------------------- | ------------------------------------------------- | ------ |
| `hedgedoc.readinessProbe.enabled`             | Enable readiness probe                            | `true` |
| `hedgedoc.readinessProbe.initialDelaySeconds` | Initial delay before readiness probe is initiated | `5`    |
| `hedgedoc.readinessProbe.timeoutSeconds`      | Timeout for readiness probe                       | `1`    |
| `hedgedoc.readinessProbe.periodSeconds`       | Period for readiness probe                        | `10`   |
| `hedgedoc.readinessProbe.successThreshold`    | Success threshold for readiness probe             | `1`    |
| `hedgedoc.readinessProbe.failureThreshold`    | Failure threshold for readiness probe             | `3`    |

### StartupProbe

| Name                                        | Description                                     | Value   |
| ------------------------------------------- | ----------------------------------------------- | ------- |
| `hedgedoc.startupProbe.enabled`             | Enable startup probe                            | `false` |
| `hedgedoc.startupProbe.initialDelaySeconds` | Initial delay before startup probe is initiated | `60`    |
| `hedgedoc.startupProbe.timeoutSeconds`      | Timeout for startup probe                       | `1`     |
| `hedgedoc.startupProbe.periodSeconds`       | Period for startup probe                        | `10`    |
| `hedgedoc.startupProbe.successThreshold`    | Success threshold for startup probe             | `1`     |
| `hedgedoc.startupProbe.failureThreshold`    | Failure threshold for startup probe             | `10`    |

### PostgreSQL HA

| Name                                        | Description                                                                                                                       | Value      |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `postgresql-ha`                             | PostgreSQL HA Bitnami chart values. Visit: [PostgreSQL HA chart docs](https://artifacthub.io/packages/helm/bitnami/postgresql-ha) |            |
| `postgresql-ha.enabled`                     | Enable PostgreSQL HA                                                                                                              | `true`     |
| `postgresql-ha.postgresql.username`         | Name for a custom user to create                                                                                                  | `hedgedoc` |
| `postgresql-ha.postgresql.password`         | Password for the `hedgedoc` user                                                                                                  | `changeme` |
| `postgresql-ha.postgresql.database`         | Name for a custom database to create                                                                                              | `hedgedoc` |
| `postgresql-ha.postgresql.postgresPassword` | PostgreSQL password for the postgres user when username is not postgres                                                           | `changeme` |
| `postgresql-ha.postgresql.repmgrPassword`   | PostgreSQL repmgr password                                                                                                        | `changeme` |
| `postgresql-ha.pgpool.adminPassword`        | Pgpool Admin password                                                                                                             | `changeme` |
| `postgresql-ha.persistence.size`            | PVC Storage Request for PostgreSQL HA volume                                                                                      | `10Gi`     |

### PostgreSQL

| Name                                  | Description                                                                                                              | Value      |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------- |
| `postgresql`                          | PostgreSQL Bitnami chart values. Visit: [PostgreSQL chart docs](https://artifacthub.io/packages/helm/bitnami/postgresql) |            |
| `postgresql.enabled`                  | Enable PostgreSQL                                                                                                        | `false`    |
| `postgresql.auth.postgresPassword`    | Password for the "postgres" admin user                                                                                   | `changeme` |
| `postgresql.auth.username`            | Name for a custom user to create                                                                                         | `hedgedoc` |
| `postgresql.auth.password`            | Password for the `hedgedoc` user                                                                                         | `changeme` |
| `postgresql.auth.database`            | Name for a custom database to create                                                                                     | `hedgedoc` |
| `postgresql.primary.persistence.size` | PVC Storage Request for PostgreSQL volume                                                                                | `10Gi`     |

### Advanced

| Name              | Description                                                        | Value     |
| ----------------- | ------------------------------------------------------------------ | --------- |
| `test.enabled`    | Set it to false to disable test-connection Pod.                    | `true`    |
| `test.image.name` | Image name for the wget container used in the test-connection Pod. | `busybox` |
| `test.image.tag`  | Image tag for the wget container used in the test-connection Pod.  | `latest`  |
| `extraDeploy`     | Array of extra objects to deploy with the release                  | `[]`      |

## Credits

Chart is heavily based on [gitea](https://gitea.com/gitea/helm-chart) one.
They worked great, so there is no need to reinvent the wheel.
