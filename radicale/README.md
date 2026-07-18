# radicale

![Version: 2.0.1](https://img.shields.io/badge/Version-2.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.7.6](https://img.shields.io/badge/AppVersion-3.7.6-informational?style=flat-square)

A Helm chart for Radicale.
Radicale is a small but powerful CalDAV (calendars, to-do lists) and CardDAV (contacts) server.
This chart uses the official, rootless ghcr.io/kozea/radicale image.

## Source Code

* <https://github.com/wittdennis/charts/tree/main/radicale>
* <https://github.com/Kozea/Radicale>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling more information can be found here: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| config | object | `{"auth":{"htpasswd":{"encryption":"bcrypt","existingSecret":"","existingSecretKey":"htpasswd","users":{}},"type":"none"},"create":true,"headers":{},"logging":{"level":"info"},"rights":{"file":{"content":"","existingSecret":"","existingSecretKey":"rights"},"type":"owner_only"},"web":{"enabled":true}}` | Radicale configuration. |
| config.auth | object | `{"htpasswd":{"encryption":"bcrypt","existingSecret":"","existingSecretKey":"htpasswd","users":{}},"type":"none"}` | Authentication backend. By default auth is disabled; configure a backend before exposing Radicale. |
| config.auth.htpasswd | object | `{"encryption":"bcrypt","existingSecret":"","existingSecretKey":"htpasswd","users":{}}` | htpasswd options (used when type is htpasswd). The chart mounts the users file and sets htpasswd_filename automatically. |
| config.auth.htpasswd.encryption | string | `"bcrypt"` | Encryption of the existingSecret htpasswd file: bcrypt | argon2 | md5 | sha256 | sha512 | plain | autodetect. Ignored for inline users (always plain). |
| config.auth.htpasswd.existingSecret | string | `""` | Existing Secret holding a pre-hashed htpasswd file. Takes precedence over users. |
| config.auth.htpasswd.existingSecretKey | string | `"htpasswd"` | Key within existingSecret that holds the htpasswd file. |
| config.auth.htpasswd.users | object | `{}` | Inline users as username -> password. Stored in the generated Secret and read with plain encryption. |
| config.auth.type | string | `"none"` | Auth backend: none | htpasswd. See https://radicale.org/v3.html#authentication |
| config.create | bool | `true` | When false no Secret is created and Radicale falls back to its own defaults. |
| config.headers | object | `{}` | Custom HTTP response headers as name -> value (e.g. for CORS). Rendered under [headers]. |
| config.logging | object | `{"level":"info"}` | Logging. |
| config.logging.level | string | `"info"` | Log level: trace | debug | info | notice | warning | error | critical | alert |
| config.rights | object | `{"file":{"content":"","existingSecret":"","existingSecretKey":"rights"},"type":"owner_only"}` | Authorization backend. |
| config.rights.file | object | `{"content":"","existingSecret":"","existingSecretKey":"rights"}` | Custom rules file (used when type is from_file). The chart mounts it and sets the file path automatically. |
| config.rights.file.content | string | `""` | Inline rights rules content. Stored in the generated Secret. |
| config.rights.file.existingSecret | string | `""` | Existing Secret holding the rights file. Takes precedence over content. |
| config.rights.file.existingSecretKey | string | `"rights"` | Key within existingSecret that holds the rights file. |
| config.rights.type | string | `"owner_only"` | Rights backend: authenticated | owner_only | owner_write | from_file. See https://radicale.org/v3.html#rights |
| config.web | object | `{"enabled":true}` | Built-in web interface. |
| config.web.enabled | bool | `true` | Enable the web UI (radicale web type internal); false disables it. |
| deploymentStrategy | object | `{"type":"Recreate"}` | Deployment strategy to use. Defaults to Recreate to avoid PVC multi-attach errors with ReadWriteOnce volumes. |
| env | object | `{}` | Additional env values to pass to the container |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"kozea/radicale","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"tcpSocket":{"port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ TCP probes are used so they stay valid regardless of the configured auth backend. |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"data":{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"5Gi"}}` | Settings for storage |
| persistence.data | object | `{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"5Gi"}` | Settings for the data pvc mounted at /var/lib/radicale (holds collections: calendars and contacts) |
| persistence.data.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.data.enabled | bool | `true` | When false an emptyDir will be provisioned. Use this only for dev purposes |
| persistence.data.size | string | `"5Gi"` | Size for the persistent volume claim. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | The image runs Radicale as the non-root radicale user (uid/gid 1000). |
| readinessProbe.tcpSocket.port | string | `"http"` |  |
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
| service | object | `{"port":5232,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `5232` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
