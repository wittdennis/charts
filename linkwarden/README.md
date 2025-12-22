# linkwarden

![Version: 0.1.0-preview.4](https://img.shields.io/badge/Version-0.1.0--preview.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.13.2](https://img.shields.io/badge/AppVersion-v2.13.2-informational?style=flat-square)

Linkwarden is a self-hosted, open-source collaborative bookmark manager to collect, read, annotate, and fully preserve what matters, all in one place.

## Source Code

* <https://github.com/wittdennis/charts/tree/master/linkwarden>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| configuration.adminUserId | int | `1` | Id of the admin user. Defaults to the first user registered |
| configuration.allowInsecureLinks | bool | `false` | Set to true to allow processing of insecure links |
| configuration.authSecret.existingSecret | string | `nil` | Required. Name of a secret containing a secret string to be used for the authentication mechanism. Secret must contain 'auth-secret' field |
| configuration.autoscrollTimeout | int | `30` | The amount of time to wait for the website to be archived (in seconds). |
| configuration.disableCredentialLogin | bool | `false` | If set to true, users won't be able to login with username and password. |
| configuration.disableNewSSOLogins | bool | `false` | If set to true, new users will not be able to login with SSO. |
| configuration.disablePreservation | bool | `false` | Set to true if you want to disable all preservation mechanisms |
| configuration.disableRegistration | bool | `false` | If set to true, registration will be disabled. |
| configuration.ignoreUrlSizeLimit | string | `nil` | Set to true to ignore header size limit when fetching links |
| configuration.indexAmount | int | `50` | Number of links that will be indexed at a time |
| configuration.maxImportSize | int | `10` | Maximum size in MB for a imported link |
| configuration.maxLinksPerUser | int | `30000` | Limits the maximum number of links per user |
| configuration.maxPreviewSize | int | `10` | Maximum size in MB of a link preview |
| configuration.meilisearch | object | `{"existingSecret":null,"host":null,"timeout":1000000}` | Settings for meilisearch integration |
| configuration.meilisearch.existingSecret | string | `nil` | Existing secret for the meilisearch master key. Must contain 'master-key' field. Required when host is set |
| configuration.meilisearch.host | string | `nil` | Host address for meilisearch. If left empty meilisearch integration will be disabled |
| configuration.meilisearch.timeout | int | `1000000` | Timeout for a meilisearch search |
| configuration.monolithCustomOptions | string | `nil` | Custom options for the monolith process |
| configuration.paginationTakeCount | int | `50` | The numbers of Links to fetch every time you reach the bottom of the webpage |
| configuration.postgres | object | `{"existingSecret":null}` | Postgres connection settings |
| configuration.postgres.existingSecret | string | `nil` | Required. Name of a secret that contains postgres connection settings. Secret must contain a field 'uri' |
| configuration.preservationSettings | object | `{"maxFileSize":10,"maxMonolithSize":100,"maxPdfSize":100,"maxReadabilitySize":100,"maxScreenshotSize":100,"readabilityTextLimit":null,"timeout":5,"worker":5}` | Settings for the preservation process |
| configuration.preservationSettings.maxFileSize | int | `10` | Maximum size in MB a link archive can have |
| configuration.preservationSettings.maxMonolithSize | int | `100` | Maximum size in MB the monolith (see: https://github.com/Y2Z/monolith) version of a link can have |
| configuration.preservationSettings.maxPdfSize | int | `100` | Maximum size in MB a pdf copy of a link can have |
| configuration.preservationSettings.maxReadabilitySize | int | `100` | Maximum size in MB a readability version of a link can have |
| configuration.preservationSettings.maxScreenshotSize | int | `100` | Maximum size in MB a screenshot of a link can have |
| configuration.preservationSettings.readabilityTextLimit | string | `nil` | If set limits the amount of text for a readability version of a link |
| configuration.preservationSettings.timeout | int | `5` | Timeout in minutes after which the archive process will be stopped |
| configuration.preservationSettings.worker | int | `5` | Number of links that will be archived in the background |
| configuration.reArchiveLimit | int | `5` | Adjusts how often a user can trigger a new archive for each link (in minutes). |
| configuration.rssPollingInterval | int | `60` | Polling interval in minutes for rss feeds |
| configuration.rssSubscriptionLimitPerUser | int | `20` | Maximum of rss subscriptions per user |
| configuration.searchFilterLimit | string | `nil` | Limits the number of filters that can be used in search |
| env | object | `{}` | Additional env values to pass to the container |
| fullnameOverride | string | `""` |  |
| gatewayApi | object | `{"additionalRules":{},"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | Block for setting up gateway api. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| gatewayApi.additionalRules | object | `{}` | Any custom rule you want to specify |
| gatewayApi.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| gatewayApi.enabled | bool | `false` | Flag to control if route should be created |
| gatewayApi.filters | list | `[]` | Filter that should be added to the default rule |
| gatewayApi.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| gatewayApi.labels | object | `{}` | Additional labels for the HTTPRoute |
| gatewayApi.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| gatewayApi.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"linkwarden/linkwarden","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"ghcr.io"` | The registry where the image is hosted |
| image.repository | string | `"linkwarden/linkwarden"` | Repository of the image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"className":null,"enabled":true,"size":"10Gi"}` | Settings for storage |
| persistence.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.enabled | bool | `true` | Controls if persistence should be enabled |
| persistence.size | string | `"10Gi"` | Size for the persistent volume claim. |
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
| replicaCount | int | `1` | This will set the replicaset count more information can be found here: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ If you want to create a HA setup with more than one replica you have to disable persistence and use S3 storage instead |
| resources | object | `{}` |  |
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

