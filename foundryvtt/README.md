# foundryvtt

![Version: 13.0.4](https://img.shields.io/badge/Version-13.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.343.0](https://img.shields.io/badge/AppVersion-12.343.0-informational?style=flat-square)

A Helm chart for Foundry VTT

## Source Code

* <https://github.com/wittdennis/charts/tree/master/foundryvtt>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.defaultWorld | string | `nil` | The default world to load when the server has started |
| config.downloadRetries | int | `3` | Number of times the container will try to download the foundry binary |
| config.enableTelemetry | bool | `false` | Defines if telemetry data are allowed to be tracked |
| config.minifyStaticFiles | bool | `true` | Defines if static files should be minified |
| existingSecret | object | `{"containsAwsConfig":false,"containsLicenseKey":false,"name":null}` | Config for the existing secret that will be referenced by the container. By default the name of the secret that is looked for is the name of the release. The secret is required to have a key foundry-username and foundry-password with the user credentials to download the foundry version. Also a "admin-key" must be provided in the secret. |
| existingSecret.containsAwsConfig | bool | `false` | Set tot true if the secret contains an awsConfig.json key |
| existingSecret.containsLicenseKey | bool | `false` | Set to true if the secret contains a license key to use. The key that is uses is foundry-license-key |
| existingSecret.name | string | `nil` | overrides the name of the secret that is referenced |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"felddy/foundryvtt","tag":null}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `nil` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":600,"periodSeconds":300}` | This is to setup the liveness probe more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext.fsGroup | int | `421` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":30}` | This is to setup the readiness probe more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| resources | object | `{}` | Resources for the foundry container |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsGroup | int | `0` |  |
| securityContext.runAsNonRoot | bool | `false` |  |
| securityContext.runAsUser | int | `0` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service | object | `{"port":80,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `80` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":null}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| storage | object | `{"className":null,"size":"10Gi"}` | This configures the storage for the data drive |
| storage.className | string | `nil` | The storage class name to use |
| storage.size | string | `"10Gi"` | The size the pv should have |
| tolerations | list | `[]` |  |

