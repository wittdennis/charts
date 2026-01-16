# linkwarden

![Version: 0.2.0-preview.1](https://img.shields.io/badge/Version-0.2.0--preview.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.13.5](https://img.shields.io/badge/AppVersion-2.13.5-informational?style=flat-square)

Linkwarden is a self-hosted, open-source collaborative bookmark manager to collect, read, annotate, and fully preserve what matters, all in one place.

## Source Code

* <https://github.com/wittdennis/charts/tree/master/linkwarden>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| deployment.kind | string | `"StatefulSet"` |  |
| env | object | `{}` | Additional env values to pass to the container |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"denniswitt/linkwarden-rootless","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"docker.io"` | The registry where the image is hosted |
| image.repository | string | `"denniswitt/linkwarden-rootless"` | Repository of the image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| linkwarden | object | `{"allowInsecureLinks":false,"auth":{"adminUserId":1,"authentik":{"clientID":null,"customName":null,"enabled":false,"existingSecret":null,"issuer":null},"disableCredentialLogin":false,"disableNewSSOLogins":false,"disableRegistration":false,"existingSecret":null},"autoscrollTimeout":30,"disablePreservation":false,"ignoreUrlSizeLimit":null,"indexAmount":50,"maxImportSize":10,"maxLinksPerUser":30000,"maxPreviewSize":10,"meilisearch":{"existingSecret":null,"host":null,"timeout":1000000},"monolithCustomOptions":null,"paginationTakeCount":50,"postgres":{"existingSecret":null},"preservationSettings":{"maxFileSize":10,"maxMonolithSize":100,"maxPdfSize":100,"maxReadabilitySize":100,"maxScreenshotSize":100,"readabilityTextLimit":null,"timeout":5,"worker":5},"reArchiveLimit":5,"rssPollingInterval":60,"rssSubscriptionLimitPerUser":20,"searchFilterLimit":null}` | Linkwarden specific settings |
| linkwarden.allowInsecureLinks | bool | `false` | Set to true to allow processing of insecure links |
| linkwarden.auth | object | `{"adminUserId":1,"authentik":{"clientID":null,"customName":null,"enabled":false,"existingSecret":null,"issuer":null},"disableCredentialLogin":false,"disableNewSSOLogins":false,"disableRegistration":false,"existingSecret":null}` | Authentication settings for linkwarden |
| linkwarden.auth.adminUserId | int | `1` | Id of the admin user. Defaults to the first user registered |
| linkwarden.auth.authentik | object | `{"clientID":null,"customName":null,"enabled":false,"existingSecret":null,"issuer":null}` | Settings for authentik |
| linkwarden.auth.authentik.clientID | string | `nil` | Client ID of the authentik application |
| linkwarden.auth.authentik.customName | string | `nil` | Optional custom provider name |
| linkwarden.auth.authentik.enabled | bool | `false` | Set to true to enable authentik |
| linkwarden.auth.authentik.existingSecret | string | `nil` | Existing kubernetes secret containing the client secret of the authentik application. Requires a 'client-secret' value |
| linkwarden.auth.authentik.issuer | string | `nil` | OpenID configuration issuer for the application |
| linkwarden.auth.disableCredentialLogin | bool | `false` | If set to true, users won't be able to login with username and password. |
| linkwarden.auth.disableNewSSOLogins | bool | `false` | If set to true, new users will not be able to login with SSO. |
| linkwarden.auth.disableRegistration | bool | `false` | If set to true, registration will be disabled. |
| linkwarden.auth.existingSecret | string | `nil` | Required. Name of a secret containing a secret string to be used for the authentication mechanism. Secret must contain 'auth-secret' field |
| linkwarden.autoscrollTimeout | int | `30` | The amount of time to wait for the website to be archived (in seconds). |
| linkwarden.disablePreservation | bool | `false` | Set to true if you want to disable all preservation mechanisms |
| linkwarden.ignoreUrlSizeLimit | string | `nil` | Set to true to ignore header size limit when fetching links |
| linkwarden.indexAmount | int | `50` | Number of links that will be indexed at a time |
| linkwarden.maxImportSize | int | `10` | Maximum size in MB for a imported link |
| linkwarden.maxLinksPerUser | int | `30000` | Limits the maximum number of links per user |
| linkwarden.maxPreviewSize | int | `10` | Maximum size in MB of a link preview |
| linkwarden.meilisearch | object | `{"existingSecret":null,"host":null,"timeout":1000000}` | Settings for meilisearch integration |
| linkwarden.meilisearch.existingSecret | string | `nil` | Existing secret for the meilisearch master key. Must contain 'master-key' field. Required when host is set |
| linkwarden.meilisearch.host | string | `nil` | Host address for meilisearch. If left empty meilisearch integration will be disabled |
| linkwarden.meilisearch.timeout | int | `1000000` | Timeout for a meilisearch search |
| linkwarden.monolithCustomOptions | string | `nil` | Custom options for the monolith process |
| linkwarden.paginationTakeCount | int | `50` | The numbers of Links to fetch every time you reach the bottom of the webpage |
| linkwarden.postgres | object | `{"existingSecret":null}` | Postgres connection settings |
| linkwarden.postgres.existingSecret | string | `nil` | Required. Name of a secret that contains postgres connection settings. Secret must contain a field 'uri' |
| linkwarden.preservationSettings | object | `{"maxFileSize":10,"maxMonolithSize":100,"maxPdfSize":100,"maxReadabilitySize":100,"maxScreenshotSize":100,"readabilityTextLimit":null,"timeout":5,"worker":5}` | Settings for the preservation process |
| linkwarden.preservationSettings.maxFileSize | int | `10` | Maximum size in MB a link archive can have |
| linkwarden.preservationSettings.maxMonolithSize | int | `100` | Maximum size in MB the monolith (see: https://github.com/Y2Z/monolith) version of a link can have |
| linkwarden.preservationSettings.maxPdfSize | int | `100` | Maximum size in MB a pdf copy of a link can have |
| linkwarden.preservationSettings.maxReadabilitySize | int | `100` | Maximum size in MB a readability version of a link can have |
| linkwarden.preservationSettings.maxScreenshotSize | int | `100` | Maximum size in MB a screenshot of a link can have |
| linkwarden.preservationSettings.readabilityTextLimit | string | `nil` | If set limits the amount of text for a readability version of a link |
| linkwarden.preservationSettings.timeout | int | `5` | Timeout in minutes after which the archive process will be stopped |
| linkwarden.preservationSettings.worker | int | `5` | Number of links that will be archived in the background |
| linkwarden.reArchiveLimit | int | `5` | Adjusts how often a user can trigger a new archive for each link (in minutes). |
| linkwarden.rssPollingInterval | int | `60` | Polling interval in minutes for rss feeds |
| linkwarden.rssSubscriptionLimitPerUser | int | `20` | Maximum of rss subscriptions per user |
| linkwarden.searchFilterLimit | string | `nil` | Limits the number of filters that can be used in search |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"enabled":true,"hostPath":null,"size":"10Gi","storageClass":null}` | Settings for storage |
| persistence.enabled | bool | `true` | If persistent volumes should be configured. Disable preservation features when you set this to false |
| persistence.hostPath | string | `nil` | Use this if you're deploying as DaemonSet |
| persistence.size | string | `"10Gi"` | Size for the persistent volume claim. |
| persistence.storageClass | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
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
| route | object | `{"additionalRules":{},"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | Block for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
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

