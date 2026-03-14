# paperless-ngx

![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.20.10](https://img.shields.io/badge/AppVersion-2.20.10-informational?style=flat-square)

A Helm chart for paperless-ngx (https://docs.paperless-ngx.com/)

## Source Code

* <https://github.com/wittdennis/charts/tree/master/paperless-ngx>
* <https://github.com/paperless-ngx/paperless-ngx>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth | object | `{"allowSignup":false,"cookieAge":1209600,"defaultGroups":"None","rememberSession":true,"sso":{"allowSignup":true,"autoRedirect":false,"autoSignup":false,"defaultGroups":null,"disableRegularLogin":false,"emailVerification":"optional","providersSecret":{"key":null,"name":null},"syncGroups":false}}` | Authentication settings |
| auth.allowSignup | bool | `false` | Allow users to signup for a new Paperless-ngx account. |
| auth.cookieAge | int | `1209600` | Login session cookie expiration. Applies if PAPERLESS_ACCOUNT_SESSION_REMEMBER is enabled |
| auth.defaultGroups | string | `"None"` | Comma seperated list of groups users will be added to when they signup |
| auth.rememberSession | bool | `true` | If false, sessions will expire at browser close, if true will use `cookieAge` for expiration |
| auth.sso | object | `{"allowSignup":true,"autoRedirect":false,"autoSignup":false,"defaultGroups":null,"disableRegularLogin":false,"emailVerification":"optional","providersSecret":{"key":null,"name":null},"syncGroups":false}` | Settings for single sign-on |
| auth.sso.allowSignup | bool | `true` | Allow users to signup for a new Paperless-ngx account using any setup third party authentication systems. |
| auth.sso.autoRedirect | bool | `false` | When enabled users will be automatically be redirected to the first SSO provider login |
| auth.sso.autoSignup | bool | `false` | Attempt to signup the user using retrieved email, username etc from the third party authentication system |
| auth.sso.defaultGroups | string | `nil` | A list of group names that users who signup via social accounts will be added to upon signup. Groups listed here must already exist. If both the `auth.defaultGroups` setting and this setting are used, the user will be added to both sets of groups. |
| auth.sso.disableRegularLogin | bool | `false` | Disables the regular frontend username / password login, i.e. once you have setup SSO. |
| auth.sso.emailVerification | string | `"optional"` | Determines whether email addresses are verified during signup. Possible value are: none, optional, mandatory Don't forget to setup email sending for this to work properly |
| auth.sso.providersSecret | object | `{"key":null,"name":null}` | Secret containing the provider configuration. See: https://docs.paperless-ngx.com/configuration/?h=redis#PAPERLESS_SOCIALACCOUNT_PROVIDERS for information how to setup. Remember to add your provider to `tweaks.apps`. |
| auth.sso.providersSecret.key | string | `nil` | Key containing the configuration |
| auth.sso.providersSecret.name | string | `nil` | Name of the secret |
| auth.sso.syncGroups | bool | `false` | Sync groups from the third party authentication system (e.g. OIDC) to Paperless-ngx. For more info see: https://docs.paperless-ngx.com/configuration/?h=redis#PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling more information can be found here: https://kubernetes.io/docs/concepts/workloads/autoscaling/ |
| database | object | `{"databaseName":null,"enableReadCache":false,"engine":"sqlite","host":null,"password":null,"passwordSecret":{"key":null,"name":null},"port":null,"readCacheTTL":3600,"user":null,"userSecret":{"key":null,"name":null}}` | Database configuration |
| database.databaseName | string | `nil` | Can be used to configure a custom name for the database defaults to paperless |
| database.enableReadCache | bool | `false` | Caches the database read query results into Redis. This can significantly improve application response times by caching database queries, at the cost of slightly increased memory usage. |
| database.engine | string | `"sqlite"` | Engine to use for the database (possible values sqlite (default), postgresql, mariadb) |
| database.host | string | `nil` | When `engine` isn't sqlite set host for your database |
| database.password | string | `nil` | When `engine` isn't sqlite use this to set the db user password for the connection |
| database.passwordSecret | object | `{"key":null,"name":null}` | When `engine` isn't sqlite use this to specify a secret containing the user password for the connection |
| database.passwordSecret.key | string | `nil` | Key of the password |
| database.passwordSecret.name | string | `nil` | Name of the secret |
| database.port | string | `nil` | When `engine` isn't sqlite can be used to set the port of the db. Defaults to 5432 for postgres and 3306 for mariadb |
| database.readCacheTTL | int | `3600` | Specifies how long (in seconds) read data should be cached. Allowed values are between 1 (one second) and 31536000 (one year). |
| database.user | string | `nil` | When `engine` isn't sqlite use this to set the db user for the connection |
| database.userSecret | object | `{"key":null,"name":null}` | When `engine` isn't sqlite use this to specify a secret containing the user for the connection |
| database.userSecret.key | string | `nil` | Key of the user |
| database.userSecret.name | string | `nil` | Name of the secret |
| email | object | `{"sending":{"from":null,"host":"localhost","passwordSecret":{"key":null,"name":null},"port":25,"useTls":false,"user":null}}` | Configuration for email |
| email.sending | object | `{"from":null,"host":"localhost","passwordSecret":{"key":null,"name":null},"port":25,"useTls":false,"user":null}` | Configuration for sending emails |
| email.sending.from | string | `nil` | From email. Defaults to `email.sending.user` if not set |
| email.sending.host | string | `"localhost"` | Host for email sending |
| email.sending.passwordSecret | object | `{"key":null,"name":null}` | Secret containing the password of the user |
| email.sending.passwordSecret.key | string | `nil` | Key containing the secret |
| email.sending.passwordSecret.name | string | `nil` | Name of the secret |
| email.sending.port | int | `25` | Port for the email host |
| email.sending.useTls | bool | `false` | Use tls for email sending |
| email.sending.user | string | `nil` | User for authentication |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"paperless-ngx/paperless-ngx","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":30,"periodSeconds":100}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| ocr | object | `{"cleanMode":"clean","colorConversionStrategy":null,"deskew":true,"imageDpi":null,"language":"eng","maxImagePixels":null,"mode":"skip","outputType":"pdfa","pageLimit":null,"rotatePages":true,"rotatePagesThreshold":12,"skipArchiveFile":"never","userArgs":null}` | Settings for ocr |
| ocr.cleanMode | string | `"clean"` | Tells paperless to use unpaper to clean any input document before sending it to tesseract. Available modes: clean, clean-final, none |
| ocr.colorConversionStrategy | string | `nil` | Controls the Ghostscript color conversion strategy when creating the archive file. This setting will only be utilized if the output is a version of PDF/A. Valid options are: CMYK, Gray, LeaveColorUnchanged, RGB or UseDeviceIndependentColor |
| ocr.deskew | bool | `true` | Tells paperless to correct skewing (slight rotation of input images mainly due to improper scanning) |
| ocr.imageDpi | string | `nil` | Paperless will OCR any images you put into the system and convert them into PDF documents. This is useful if your scanner produces images. In order to do so, paperless needs to know the DPI of the image. Most images from scanners will have this information embedded and paperless will detect and use that information. In case this fails, it uses this value as a fallback. |
| ocr.language | string | `"eng"` | Customize the language that paperless will attempt to use when parsing documents. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_OCR_LANGUAGE for more info. |
| ocr.maxImagePixels | string | `nil` | Paperless will raise a warning when OCRing images which are over this limit and will not OCR images which are more than twice this limit. Note this does not prevent the document from being consumed, but could result in missing text content. |
| ocr.mode | string | `"skip"` | Tell paperless when and how to perform ocr on your documents. Three modes are available: skip, redo, force. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_OCR_MODE for more info. |
| ocr.outputType | string | `"pdfa"` | Specify the the type of PDF documents that paperless should produce. Available types: pdf, pdfa, pdf-1, pdf-2, pdf-3 |
| ocr.pageLimit | string | `nil` | Tells paperless to use only the specified amount of pages for OCR. Documents with less than the specified amount of pages get OCR'ed completely. |
| ocr.rotatePages | bool | `true` | Tells paperless to correct page rotation (90°, 180° and 270° rotation). |
| ocr.rotatePagesThreshold | int | `12` | Adjust the threshold for automatic page rotation by PAPERLESS_OCR_ROTATE_PAGES. This is an arbitrary value reported by tesseract. "15" is a very conservative value, whereas "2" is a very aggressive option and will often result in correctly rotated pages being rotated as well. |
| ocr.skipArchiveFile | string | `"never"` | Specify when you would like paperless to skip creating an archived version of your documents. Available modes are never, with_text, always |
| ocr.userArgs | string | `nil` | OCRmyPDF offers many more options. Use this parameter to specify any additional arguments you wish to pass to OCRmyPDF. Since Paperless uses the API of OCRmyPDF, you have to specify these in a format that can be passed to the API. Specify arguments as a JSON dictionary |
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
| tweaks | object | `{"apps":null}` | Various software tweaks for the paperless application |
| tweaks.apps | string | `nil` | A comma-separated list of Django apps to be included in Django's INSTALLED_APPS |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
