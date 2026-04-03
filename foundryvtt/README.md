# foundryvtt

![Version: 14.3.0](https://img.shields.io/badge/Version-14.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 14.359.0](https://img.shields.io/badge/AppVersion-14.359.0-informational?style=flat-square)

A Helm chart for Foundry VTT

## Source Code

* <https://github.com/wittdennis/charts/tree/master/foundryvtt>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.adminKeySecret | object | `{"key":"admin-key","name":null}` | Secret containing the admin password for the instance |
| config.adminKeySecret.key | string | `"admin-key"` | Key containing the admin password |
| config.adminKeySecret.name | string | `nil` | Name of the secret |
| config.awsConfigSecret | object | `{"key":"awsConfig.json","name":null}` | Secret containing awsConfig.json |
| config.awsConfigSecret.key | string | `"awsConfig.json"` | Key containing the aws config |
| config.awsConfigSecret.name | string | `nil` | Name of the secret |
| config.cssTheme | string | `"dark"` | Choose the CSS theme for the setup page. Valid values are dark, fantasy, and scifi. |
| config.defaultWorld | string | `nil` | The default world to load when the server has started |
| config.deleteNeDbFiles | bool | `false` | Set to true to automatically delete legacy NeDB .db files after they have been migrated to the LevelDB format introduced in Version 11. Enabling this recovers disk space but removes the ability to roll back to a pre-migration state. Only relevant for data volumes previously used with Foundry Version 10 or earlier. |
| config.disableBackups | bool | `false` | Set to true to disable the automatic backup of world data that Foundry creates before performing major version migrations. Users with an external backup strategy or constrained storage may wish to enable this. |
| config.downloadRetries | int | `3` | Number of times the container will try to download the foundry binary |
| config.enableTelemetry | bool | `false` | Defines if telemetry data are allowed to be tracked |
| config.foundryAuthSecret | object | `{"name":null,"passwordKey":"password","usernameKey":"username"}` | Secret containing username and password foundryvtt.com needed to download the foundry binaries |
| config.foundryAuthSecret.name | string | `nil` | Name of the secret containing the login data |
| config.foundryAuthSecret.passwordKey | string | `"password"` | Key containing the password |
| config.foundryAuthSecret.usernameKey | string | `"username"` | Key containing the username |
| config.licenseKeySecret | object | `{"key":"license-key","name":null}` | Can be used to specify a specific foundry license key |
| config.licenseKeySecret.key | string | `"license-key"` | Key containing the license key |
| config.licenseKeySecret.name | string | `nil` | Name of the secret containing the license key |
| config.logFileSize | string | `"64M"` | The maximum size a log file can reach before it is rotated. Units must be included. e.g.; 1024k, 64m, 1g. |
| config.maxNumberOfLogFiles | int | `10` | The maximum number of log files to retain before older ones are deleted. |
| config.minifyStaticFiles | bool | `true` | Defines if static files should be minified |
| config.preserveConfig | bool | `false` | Defines if in-app configuration changes should be preserved across container restarts |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"felddy/foundryvtt","tag":null}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"ghcr.io"` | Registry of the image |
| image.repository | string | `"felddy/foundryvtt"` | Repository of the image |
| image.tag | string | `nil` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":600,"periodSeconds":300}` | This is to setup the liveness probe more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":30}` | This is to setup the readiness probe more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| resources | object | `{}` | Resources for the foundry container |
| route | object | `{"additionalRules":[],"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | list | `[]` | Any custom rule you want to specify |
| route.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| route.enabled | bool | `false` | Flag to control if route should be created |
| route.filters | list | `[]` | Filter that should be added to the default rule |
| route.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| route.labels | object | `{}` | Additional labels for the HTTPRoute |
| route.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| route.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsGroup | int | `1000` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
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
