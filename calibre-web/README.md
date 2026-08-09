# calibre-web

![Version: 1.0.4](https://img.shields.io/badge/Version-1.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.3](https://img.shields.io/badge/AppVersion-1.0.3-informational?style=flat-square)

A Helm chart for Calibre-Web.
Calibre-Web is a web app for browsing, reading and downloading eBooks stored in a Calibre database.
This chart expects a rootless image with bundled Calibre binaries so it can run with a read-only root filesystem.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Dennis Witt |  | <https://github.com/wittdennis> |
## Source Code

* <https://github.com/wittdennis/charts/tree/main/calibre-web>
* <https://github.com/janeczku/calibre-web>
* <https://github.com/wittdennis/container-calibre-web>

## Requirements

Helm 4. The bundled `values.schema.json` is written against JSON Schema draft 2020-12, which earlier Helm releases cannot parse.

## Single replica

`replicaCount` accepts only `0` and `1`. Calibre-Web keeps its settings in `app.db` and the library metadata in `metadata.db`, both SQLite files on a `ReadWriteOnce` volume, so a second replica would corrupt them. Rendering fails for anything higher. Set `replicaCount: 0` to scale down and release the volume for maintenance.

The deployment strategy defaults to `Recreate` for the same reason: a rolling update would need two pods attached to the same volume at once.

## First start

The library path is not configurable through values — Calibre-Web stores it in `app.db`, which only its own UI writes. On first start, open the app and point it at `/books`, where `persistence.data` is mounted. `persistence.config` holds `app.db` and the cache and must stay writable.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| deploymentStrategy | object | `{"type":"Recreate"}` | Deployment strategy to use. Defaults to Recreate to avoid PVC multi-attach errors with ReadWriteOnce volumes. |
| env | list | `[]` | Additional env values to pass to the container. The image already sets CALIBRE_DBPATH, CACHE_DIRECTORY and the Calibre temp/config paths so it runs on a read-only root filesystem. |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"wittdennis/calibre-web","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ Custom rootless, read-only image (Calibre-Web + bundled Calibre binaries). |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"config":{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"1Gi"},"data":{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"10Gi"}}` | Settings for storage |
| persistence.config | object | `{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"1Gi"}` | Settings for the config pvc mounted at /config (holds the app database and settings) |
| persistence.config.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.config.enabled | bool | `true` | When false an emptyDir will be provisioned. Use this only for dev purposes |
| persistence.config.size | string | `"1Gi"` | Size for the persistent volume claim. |
| persistence.data | object | `{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"10Gi"}` | Settings for the library pvc mounted at /books (holds the Calibre library and eBook files) |
| persistence.data.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.data.enabled | bool | `true` | When false an emptyDir will be provisioned. Use this only for dev purposes |
| persistence.data.size | string | `"10Gi"` | Size for the persistent volume claim. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | The LinuxServer image is run rootless as an arbitrary user; PUID/PGID no longer apply and file ownership is handled through fsGroup. |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` | Replica count. Only 0 (scaled down) and 1 are valid: the settings db and the Calibre library are SQLite databases on a ReadWriteOnce volume, so a second replica would corrupt them. Anything higher fails the render. |
| resources | object | `{}` |  |
| route | object | `{"additionalRules":[],"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | list | `[]` | Any custom rule you want to specify. Spliced into the HTTPRoute rules list, so it has to be a list of rules. |
| route.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| route.enabled | bool | `false` | Flag to control if route should be created |
| route.filters | list | `[]` | Filter that should be added to the default rule |
| route.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| route.labels | object | `{}` | Additional labels for the HTTPRoute |
| route.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| route.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.privileged | bool | `false` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service | object | `{"annotations":{},"labels":{},"port":80,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.annotations | object | `{}` | Additional annotations for the service |
| service.labels | object | `{}` | Additional labels for the service |
| service.port | int | `80` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"failureThreshold":30,"httpGet":{"path":"/","port":"http"},"periodSeconds":10}` | Startup probe. Gives the app time to migrate its settings db and scan the library before the liveness probe takes over. Set to `null` to disable |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
