# home-assistant-otbr

![Version: 1.3.2](https://img.shields.io/badge/Version-1.3.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.0.2](https://img.shields.io/badge/AppVersion-3.0.2-informational?style=flat-square)

A Helm chart for Kubernetes

## Source Code

* <https://github.com/wittdennis/charts/tree/master/home-assistant-otbr>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| enableServiceLinks | bool | `false` |  |
| fullnameOverride | string | `""` |  |
| homeAssistantOtbr | object | `{"backboneInterface":"eth0","baudrate":460800,"betaMode":false,"firewall":false,"flowControl":true,"nat64":false,"networkDeviceAddress":null,"rcpMountPath":"/dev/ttyUSB0","restPort":8081,"webPort":7586}` | OpenThread Border Router settings |
| homeAssistantOtbr.backboneInterface | string | `"eth0"` | The physical network interface to use for routing |
| homeAssistantOtbr.baudrate | int | `460800` | Serial port baudrate (depends on firmware) |
| homeAssistantOtbr.betaMode | bool | `false` | Enables beta mode. (Needed for Thread 1.4) |
| homeAssistantOtbr.firewall | bool | `false` | If iptables firewall should be configured |
| homeAssistantOtbr.flowControl | bool | `true` | Toggles flow control |
| homeAssistantOtbr.nat64 | bool | `false` | If nat64 should be enabled |
| homeAssistantOtbr.networkDeviceAddress | string | `nil` | If you're using a network device specify the network address of the device including the port |
| homeAssistantOtbr.rcpMountPath | string | `"/dev/ttyUSB0"` | The mount path for the thread receiver |
| homeAssistantOtbr.restPort | int | `8081` | Port of the rest api |
| homeAssistantOtbr.webPort | int | `7586` | Port of the web ui |
| image.pullPolicy | string | `"Always"` |  |
| image.registry | string | `"ghcr.io"` | The registry where the image is hosted |
| image.repository | string | `"wittdennis/homeassistant-otbr"` | Image repository |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.rest.annotations | object | `{}` |  |
| ingress.rest.className | string | `""` |  |
| ingress.rest.enabled | bool | `false` |  |
| ingress.rest.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.rest.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.rest.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.rest.tls | list | `[]` |  |
| ingress.web.annotations | object | `{}` |  |
| ingress.web.className | string | `""` |  |
| ingress.web.enabled | bool | `false` |  |
| ingress.web.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.web.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.web.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.web.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"web"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"existingVolumeClaim":null,"size":"1Gi","storageClassName":null}` | Persistence settings |
| persistence.annotations | object | `{}` | Additional annotations for the PVC |
| persistence.enabled | bool | `true` | If disabled uses emptyDir causing data loss on pod restarts |
| persistence.existingVolumeClaim | string | `nil` | Set this if a already existing pvc should be used otherwise a new one will be created |
| persistence.storageClassName | string | `nil` | The storage class to use when creating a new pvc |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"web"` |  |
| resources | object | `{}` |  |
| route | object | `{"rest":{"additionalRules":{},"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]},"web":{"additionalRules":{},"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.rest.additionalRules | object | `{}` | Any custom rule you want to specify |
| route.rest.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| route.rest.enabled | bool | `false` | Flag to control if route should be created |
| route.rest.filters | list | `[]` | Filter that should be added to the default rule |
| route.rest.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| route.rest.labels | object | `{}` | Additional labels for the HTTPRoute |
| route.rest.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| route.rest.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| route.web.additionalRules | object | `{}` | Any custom rule you want to specify |
| route.web.annotations | object | `{}` | Additional annotations for the HTTPRoute |
| route.web.enabled | bool | `false` | Flag to control if route should be created |
| route.web.filters | list | `[]` | Filter that should be added to the default rule |
| route.web.hostnames | list | `[]` | Hostnames of the HTTPRoute |
| route.web.labels | object | `{}` | Additional labels for the HTTPRoute |
| route.web.matches | list | `[{"path":{"type":"PathPrefix","value":"/"}}]` | Matches for the default rule |
| route.web.parentRefs | list | `[]` | Gateway reference that the HTTPRoute should bind against |
| service.rest.port | int | `80` |  |
| service.rest.type | string | `"ClusterIP"` |  |
| service.web.port | int | `80` |  |
| service.web.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
