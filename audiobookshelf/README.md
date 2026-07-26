# audiobookshelf

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.35.1](https://img.shields.io/badge/AppVersion-2.35.1-informational?style=flat-square)

A Helm chart for Audiobookshelf.
Audiobookshelf is a self-hosted audiobook and podcast server that syncs listening progress across clients.
Runs rootless with a read-only root filesystem. Libraries are configured in the app UI against the paths supplied through mediaMounts.

## Source Code

* <https://github.com/wittdennis/charts/tree/main/audiobookshelf>
* <https://github.com/advplyr/audiobookshelf>

## Requirements

Helm 4. The bundled `values.schema.json` is written against JSON Schema draft 2020-12, which earlier Helm releases cannot parse.

## Single replica

`replicaCount` accepts only `0` and `1`. Audiobookshelf keeps its libraries, users and listening progress in a single SQLite database on a `ReadWriteOnce` volume, so a second replica would corrupt it. Rendering fails for anything higher. Set `replicaCount: 0` to scale down and release the volumes for maintenance.

The deployment strategy defaults to `Recreate` for the same reason: a rolling update would need two pods attached to the same volumes at once.

## Media volumes

Libraries are added in the app UI against paths inside the container, so the chart cannot know how many volumes are needed or where they belong. `mediaMounts` supplies them, and each entry either reuses a volume you already have or is provisioned by the chart.

The default provisions a single 50Gi volume at `/audiobooks`, so a plain `helm install` works on any cluster with a default storage class:

```yaml
mediaMounts:
  - name: audiobooks
    mountPath: /audiobooks
    size: 50Gi
    accessMode: ReadWriteOnce
    className: ~
```

Point it at storage you already have with `existingClaim` instead. The chart provisions nothing for those entries:

```yaml
mediaMounts:
  - name: audiobooks
    mountPath: /audiobooks
    existingClaim: media-audiobooks
    readOnly: true
  - name: podcasts
    mountPath: /podcasts
    size: 20Gi
```

`mediaMounts` is a list, so supplying your own replaces the default entry rather than adding to it. `name` doubles as the volume name and as the suffix of any claim the chart creates, so it has to be unique and cannot be `tmp`, `config` or `metadata`. An entry with neither `existingClaim` nor `size` fails the render.

## First start

Open the app, create the root user, then add a library for each `mediaMounts` path. The library paths are not configurable through values — Audiobookshelf stores them in its own database, which only its UI writes.

`persistence.config` holds the database and must stay writable. `persistence.metadata` holds the cache, streams, covers, downloads, logs and, unless `audiobookshelf.backupPath` says otherwise, the backups — so it grows with the size of the library.

## The ffmpeg check

Audiobookshelf checks for ffmpeg and ffprobe on startup and accepts only version 5.1. The image ships a newer build, so the check usually rejects it and downloads its own copy. With the default read-only root filesystem that copy lands in the config volume, which means the first start needs network egress to GitHub and takes noticeably longer — hence the five minute budget on the startup probe.

To skip the download and use the binaries already in the image, set all three:

```yaml
binaries:
  skipCheck: true
  ffmpegPath: /usr/bin/ffmpeg
  ffprobePath: /usr/bin/ffprobe
```

Both paths are required once `skipCheck` is true, because Audiobookshelf exits during startup when the check is skipped without them. The render fails rather than letting the pod crash-loop.

## Serving under a subpath

Audiobookshelf serves from `/audiobookshelf` and rewrites requests that arrive without the prefix, so it answers at the root as well and needs no configuration for the common case. Set `audiobookshelf.routerBasePath` to serve it somewhere else.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| audiobookshelf | object | `{"backupPath":"","podcast":{"downloadTimeout":""},"query":{"logging":"","profiling":""},"routerBasePath":"","sqlite":{"cacheSize":"","mmapSize":"","tempStore":""},"timezone":""}` | Settings that Audiobookshelf reads from its environment. Empty values are left out so the application default applies. |
| audiobookshelf.backupPath | string | `""` | Where backups are written. Empty leaves them under the metadata volume in /metadata/backups. Point this at a media mount to keep backups off that volume. |
| audiobookshelf.podcast.downloadTimeout | string | `""` | Timeout in milliseconds for podcast downloads. 0 disables the timeout. |
| audiobookshelf.query.logging | string | `""` | Log SQL queries. `log` logs the queries, `benchmark` also logs their runtime. |
| audiobookshelf.query.profiling | string | `""` | Experimental profiling of specific database queries. |
| audiobookshelf.routerBasePath | string | `""` | Path to serve the app under. Audiobookshelf defaults to /audiobookshelf and rewrites requests that do not carry the prefix, so it answers on / either way. |
| audiobookshelf.sqlite.cacheSize | string | `""` | cache_size pragma for the SQLite database. |
| audiobookshelf.sqlite.mmapSize | string | `""` | mmap_size pragma for the SQLite database. |
| audiobookshelf.sqlite.tempStore | string | `""` | temp_store pragma for the SQLite database. |
| audiobookshelf.timezone | string | `""` | Time zone of the container, e.g. Europe/Berlin. |
| binaries | object | `{"ffmpegPath":"","ffprobePath":"","skipCheck":false}` | Audiobookshelf checks for ffmpeg and ffprobe on startup and accepts only version 5.1. The image ships a newer build, so on first start it downloads its own copy into the config volume, which needs network egress. Set `skipCheck` to use the bundled binaries as they are. |
| binaries.ffmpegPath | string | `""` | Path to the ffmpeg binary. In the upstream image this is /usr/bin/ffmpeg. |
| binaries.ffprobePath | string | `""` | Path to the ffprobe binary. In the upstream image this is /usr/bin/ffprobe. |
| binaries.skipCheck | bool | `false` | Skip the startup binary check. Requires both paths below, because Audiobookshelf exits when they are unset. |
| deploymentStrategy | object | `{"type":"Recreate"}` | Deployment strategy to use. Defaults to Recreate to avoid PVC multi-attach errors with ReadWriteOnce volumes. |
| env | list | `[]` | Additional env values to pass to the container. Spliced in after the values below, so an entry here overrides one the chart derived. |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"advplyr/audiobookshelf","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"httpGet":{"path":"/healthcheck","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| mediaMounts | list | a provisioned 50Gi volume at /audiobooks | Volumes holding the audio files. Libraries are added in the app UI against these mountPaths, so the chart cannot know how many are needed. Set `existingClaim` to reuse a volume you already have, or leave it unset and give a `size` to have the chart provision one. This is a list, so overriding it replaces the default entry entirely. |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| persistence | object | `{"config":{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"2Gi"},"metadata":{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"10Gi"}}` | Settings for storage |
| persistence.config | object | `{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"2Gi"}` | Settings for the config pvc mounted at /config. Holds the SQLite database and, when the binary check downloads ffmpeg, that copy too. |
| persistence.config.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.config.enabled | bool | `true` | When false an emptyDir will be provisioned. Use this only for dev purposes |
| persistence.config.size | string | `"2Gi"` | Size for the persistent volume claim. |
| persistence.metadata | object | `{"accessMode":"ReadWriteOnce","className":null,"enabled":true,"existingVolumeClaim":null,"size":"10Gi"}` | Settings for the metadata pvc mounted at /metadata. Holds cache, streams, covers, downloads, backups and logs, so it grows with the size of the library. |
| persistence.metadata.className | string | `nil` | Storage class to use for persistent storage. If left empty default storage class will be used. |
| persistence.metadata.enabled | bool | `true` | When false an emptyDir will be provisioned. Use this only for dev purposes |
| persistence.metadata.size | string | `"10Gi"` | Size for the persistent volume claim. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | The upstream image declares no USER and would run as root. It works fine as an arbitrary user instead, so file ownership is handled through fsGroup. |
| readinessProbe.httpGet.path | string | `"/healthcheck"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` | Replica count. Only 0 (scaled down) and 1 are valid: Audiobookshelf keeps its database in a SQLite file on a ReadWriteOnce volume, so a second replica would corrupt it. Anything higher fails the render. |
| resources | object | `{}` |  |
| route | object | `{"additionalRules":[],"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | list | `[]` | Any custom rule you want to specify. |
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
| startupProbe | object | `{"failureThreshold":30,"httpGet":{"path":"/healthcheck","port":"http"},"periodSeconds":10}` | Startup probe. The failureThreshold allows five minutes, because a first start may download ffmpeg before the app begins listening. Set to `null` to disable; `{}` merges with these defaults and leaves the probe in place. |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
