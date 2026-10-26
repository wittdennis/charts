# music-assistant

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.10.8](https://img.shields.io/badge/AppVersion-2.10.8-informational?style=flat-square)

Helm chart for Music Assistant server

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Dennis Witt |  | <https://github.com/wittdennis> |
## Source Code

* <https://github.com/wittdennis/charts/tree/main/music-assistant>
* <https://github.com/music-assistant/server>

## AirPlay

The server runs as an unprivileged user with all capabilities dropped. AirPlay playback works, but AirPlay 2 multi-room sync does not: it relies on a PTP clock daemon that binds the privileged UDP ports 319 and 320. The server logs a warning on startup and falls back to NTP timing, so grouped AirPlay 2 speakers may drift apart.

An added capability is not effective for a non-root user, because Kubernetes grants no ambient capabilities. The unprivileged port range cannot be lowered per pod either, because `net.ipv4.ip_unprivileged_port_start` belongs to the node's network namespace on the host network.

### Lowering the unprivileged port range on the node

This keeps the server unprivileged. Set the sysctl on every node the server can be scheduled on, and persist it across reboots:

```sh
sysctl -w net.ipv4.ip_unprivileged_port_start=319
echo 'net.ipv4.ip_unprivileged_port_start = 319' > /etc/sysctl.d/90-music-assistant.conf
```

The sysctl is scoped to a network namespace, so it applies only to processes on the node's host network. Pods with their own network keep the default of 1024. It covers IPv6 as well. UDP 319 and 320 have to be free on the node, so nothing else, such as `ptp4l`, may already listen on them.

### Running as root

If the node cannot be changed, run the server as root and add the `NET_BIND_SERVICE` capability:

```yaml
podSecurityContext:
  runAsNonRoot: false
  runAsUser: 0
  runAsGroup: 0
securityContext:
  runAsNonRoot: false
  capabilities:
    add:
      - NET_BIND_SERVICE
```

Helm merges these into the defaults, so `runAsNonRoot` has to be set to `false` explicitly in both contexts, otherwise the kubelet refuses to start a root container. Everything else stays in place: all other capabilities remain dropped, privilege escalation stays disabled and the root filesystem stays read-only. UDP 319 and 320 have to be free on the node here as well.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| enableServiceLinks | bool | `true` | Indicates whether information about services should be injected into pod's environment variables, matching the syntax of Docker links |
| extraArgs | list | `[]` | Additional command line arguments appended to the server container args |
| extraEnv | list | `[]` | Additional environment variables for the server container, e.g. `[{"name": "TZ", "value": "Europe/Berlin"}]` |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"music-assistant/server","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"ghcr.io"` | Container registry where the repository is hosted |
| image.repository | string | `"music-assistant/server"` | Container repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"httpGet":{"path":"/info","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| log.logLevel | string | `"info"` | Global logging level, possible options are: critical, error, warning, info, debug, verbose |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` | Selector to control on which node the pods should be running |
| persistence | object | `{"size":"5Gi","storageClassName":null}` | Settings for storage |
| persistence.size | string | `"5Gi"` | Size for the persistent volume claim. Holds the database, settings and the artwork cache |
| persistence.storageClassName | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the pod. More information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| port | int | `8095` | Port of the web server and API. Binds on the node directly because the pod uses the host network. The server reads the port from its own settings, so this has to match Settings > System > Web Server |
| readinessProbe.httpGet.path | string | `"/info"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| resources | object | `{}` |  |
| route | object | `{"additionalRules":[],"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | list | `[]` | Any custom rule you want to specify |
| route.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| route.enabled | bool | `false` | Flag to control if route should be created |
| route.filters | list | `[]` | Filter that should be added to the default rule |
| route.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| route.labels | object | `{}` | Additional labels for the HTTPRoute |
| route.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| route.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| safeMode | bool | `false` | Start in safe mode, which only loads the core controllers and no providers. Useful to recover from a misbehaving provider |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | Security context of the server container. AirPlay 2 multi-room PTP sync binds the privileged UDP ports 319/320 and otherwise falls back to NTP timing. See the AirPlay section of the README for the options |
| service | object | `{"port":80,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `80` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"failureThreshold":30,"httpGet":{"path":"/info","port":"http"},"periodSeconds":10}` | Used to define a startup probe. More information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output StatefulSet definition. |
| volumes | list | `[]` | Additional volumes on the output StatefulSet definition, e.g. a local music library |
