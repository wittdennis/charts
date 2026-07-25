# calibre-web

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.6.26](https://img.shields.io/badge/AppVersion-0.6.26-informational?style=flat-square)

A Helm chart for Calibre-Web.
Calibre-Web is a web app for browsing, reading and downloading eBooks stored in a Calibre database.
This chart expects a rootless image with bundled Calibre binaries so it can run with a read-only root filesystem.

## Source Code

* <https://github.com/wittdennis/charts/tree/main/calibre-web>
* <https://github.com/janeczku/calibre-web>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling more information can be found here: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| deploymentStrategy | object | `{"type":"Recreate"}` | Deployment strategy to use. Defaults to Recreate to avoid PVC multi-attach errors with ReadWriteOnce volumes. |
| env | object | `{}` | Additional env values to pass to the container. The image already sets CALIBRE_DBPATH, CACHE_DIRECTORY and the Calibre temp/config paths so it runs on a read-only root filesystem. |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"wittdennis/calibre-web","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ NOTE: points at a custom rootless, read-only image built from the accompanying Dockerfile (Calibre-Web + bundled Calibre binaries). Set this to wherever you publish that image. |
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
| replicaCount | int | `1` | This will set the replicaset count more information can be found here: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| resources | object | `{}` |  |
| route | object | `{"additionalRules":{},"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | object | `{}` | Any custom rule you want to specify |
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
| service | object | `{"port":80,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `80` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
