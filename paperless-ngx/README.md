# paperless-ngx

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.20.10](https://img.shields.io/badge/AppVersion-2.20.10-informational?style=flat-square)

A Helm chart for paperless-ngx (https://docs.paperless-ngx.com/)

## Source Code

* <https://github.com/wittdennis/charts/tree/master/paperless-ngx>
* <https://github.com/paperless-ngx/paperless-ngx>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling more information can be found here: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"paperless-ngx/paperless-ngx","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":30,"periodSeconds":100}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"consume":{"accessMode":"ReadWriteOnce","enabled":false,"existingVolumeClaim":null,"size":"10Gi","storageClass":null},"data":{"accessMode":"ReadWriteOnce","enabled":true,"existingVolumeClaim":null,"size":"10Gi","storageClass":null},"export":{"accessMode":"ReadWriteOnce","enabled":false,"existingVolumeClaim":null,"size":"10Gi","storageClass":null},"media":{"accessMode":"ReadWriteOnce","enabled":true,"existingVolumeClaim":null,"size":"100Gi","storageClass":null}}` | Configuration for data persistence |
| persistence.consume | object | `{"accessMode":"ReadWriteOnce","enabled":false,"existingVolumeClaim":null,"size":"10Gi","storageClass":null}` | Setting for the consume directory. Paperless will process documents saved to this |
| persistence.consume.accessMode | string | `"ReadWriteOnce"` | Set the access mode for the created pvc |
| persistence.consume.enabled | bool | `false` | When set to false emptyDir will be created which will lead to data loss on pod restart |
| persistence.consume.existingVolumeClaim | string | `nil` | Set the name of a existing persistent volume claim in order to not create a new one |
| persistence.consume.size | string | `"10Gi"` | Size of the persistent volume |
| persistence.consume.storageClass | string | `nil` | Use this to specify the storage class that should be used for pvc creation |
| persistence.data | object | `{"accessMode":"ReadWriteOnce","enabled":true,"existingVolumeClaim":null,"size":"10Gi","storageClass":null}` | Setting for auxiliary data like sqlite database |
| persistence.data.accessMode | string | `"ReadWriteOnce"` | Set the access mode for the created pvc |
| persistence.data.enabled | bool | `true` | When set to false emptyDir will be created which will lead to data loss on pod restart |
| persistence.data.existingVolumeClaim | string | `nil` | Set the name of a existing persistent volume claim in order to not create a new one |
| persistence.data.size | string | `"10Gi"` | Size of the persistent volume |
| persistence.data.storageClass | string | `nil` | Use this to specify the storage class that should be used for pvc creation |
| persistence.export | object | `{"accessMode":"ReadWriteOnce","enabled":false,"existingVolumeClaim":null,"size":"10Gi","storageClass":null}` | Setting for the export directory. This will be used for data exports. |
| persistence.export.accessMode | string | `"ReadWriteOnce"` | Set the access mode for the created pvc |
| persistence.export.enabled | bool | `false` | When set to false emptyDir will be created which will lead to data loss on pod restart |
| persistence.export.existingVolumeClaim | string | `nil` | Set the name of a existing persistent volume claim in order to not create a new one |
| persistence.export.size | string | `"10Gi"` | Size of the persistent volume |
| persistence.export.storageClass | string | `nil` | Use this to specify the storage class that should be used for pvc creation |
| persistence.media | object | `{"accessMode":"ReadWriteOnce","enabled":true,"existingVolumeClaim":null,"size":"100Gi","storageClass":null}` | Setting for the media directory. This is where the documents are stored |
| persistence.media.accessMode | string | `"ReadWriteOnce"` | Set the access mode for the created pvc |
| persistence.media.enabled | bool | `true` | When set to false emptyDir will be created which will lead to data loss on pod restart |
| persistence.media.existingVolumeClaim | string | `nil` | Set the name of a existing persistent volume claim in order to not create a new one |
| persistence.media.size | string | `"100Gi"` | Size of the persistent volume |
| persistence.media.storageClass | string | `nil` | Use this to specify the storage class that should be used for pvc creation |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| redis | object | `{"connectionSecret":{"key":null,"name":null},"connectionUrl":null,"prefix":null}` | Configuration for redis connection |
| redis.connectionSecret | object | `{"key":null,"name":null}` | Can be used as an alternative to `connectionUrl`. Takes precedence. |
| redis.connectionSecret.key | string | `nil` | Key of the connection url |
| redis.connectionSecret.name | string | `nil` | Name of the secret containing the connection url |
| redis.connectionUrl | string | `nil` | The url to be used to make the redis connection |
| redis.prefix | string | `nil` | Prefix to be used in Redis for keys and channels. Useful for sharing one Redis server among multiple Paperless instances. |
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
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |

