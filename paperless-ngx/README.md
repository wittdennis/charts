# paperless-ngx

![Version: 2.1.0](https://img.shields.io/badge/Version-2.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.0.5](https://img.shields.io/badge/AppVersion-3.0.5-informational?style=flat-square)

A Helm chart for paperless-ngx (https://docs.paperless-ngx.com/)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Dennis Witt |  | <https://github.com/wittdennis> |
## Source Code

* <https://github.com/wittdennis/charts/tree/main/paperless-ngx>
* <https://github.com/paperless-ngx/paperless-ngx>

## Requirements

Helm 4. The bundled `values.schema.json` is written against JSON Schema draft 2020-12, which earlier Helm releases cannot parse.

## Upgrading to 2.0.0

Chart 2.0.0 moves from paperless-ngx 2.20.15 to 3.0.2. The application release contains breaking changes, so read this section before upgrading. Upstream reference: [v3 migration guide](https://docs.paperless-ngx.com/migration-v3/).

Paperless-ngx 3.0 can only be upgraded from 2.20.15, which is the version chart 1.3.0 shipped. If you are coming from an older chart release, upgrade to chart 1.3.0 first and let it start once.

### Renamed and changed values

| Chart 1.x                                   | Chart 2.0.0                                       | Notes                                                                                |
| ------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `ocr.skipArchiveFile: never`                | `ocr.archiveFileGeneration: always`               | Upstream split OCR control from archive control. Rendering fails if the old key is still set. |
| `ocr.skipArchiveFile: with_text`            | `ocr.archiveFileGeneration: auto`                 | New default                                                                          |
| `ocr.skipArchiveFile: always`               | `ocr.archiveFileGeneration: never`                |                                                                                      |
| `ocr.mode: skip`                            | `ocr.mode: auto`                                  | `skip` and `skip_noarchive` are gone; the mode set is now `auto`, `redo`, `force`, `off` |

The default for archive generation changed meaning: chart 1.x defaulted to `skipArchiveFile: never`, i.e. *always* produce a PDF/A archive. Chart 2.0.0 follows the new upstream default `archiveFileGeneration: auto`, which **skips the archive for born-digital PDFs that already contain text**. Set `ocr.archiveFileGeneration: always` to keep the previous behavior.

`ocr.skipArchiveFile` is rejected rather than silently ignored — if it is still present in your values, `helm upgrade` fails with a message pointing at its replacement.

### New values

| Value                                     | Why you may want it                                                                                              |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `documentConsumption.pollingInterval`     | Native filesystem notifications are unreliable on NFS/SMB-backed volumes. Set a positive number of seconds to poll the consume directory instead. |
| `documentConsumption.stabilityDelay`      | Seconds a file must stay unchanged before consumption. Raise it for slow storage or scanners that write incrementally. |
| `documentConsumption.deleteDuplicates`    | Paperless-ngx 3.0 consumes duplicates and flags them in the UI instead of rejecting them. Set to `true` to restore rejection. |
| `hosting.trustedProxies`                  | Set to the IPs of your ingress controller or gateway. Without it allauth cannot determine the client IP for login rate limiting and logins may fail with `403 Forbidden`. |
| `hosting.trustedClientIpHeader`           | For proxies that use a dedicated header such as `X-Real-IP` or `CF-Connecting-IP` instead of `X-Forwarded-For`.   |
| `database.options`                        | Replaces the removed upstream SSL, timeout and pool size variables with a single comma-delimited option string.   |
| `ai.*`                                    | Opt-in access to the new AI suggestion and RAG features. Disabled by default — see [AI features](#ai-features).    |

`PAPERLESS_SUPERVISORD_WORKING_DIR` is no longer set — it became a no-op upstream. Read-only root filesystem support still works through `S6_READ_ONLY_ROOT`, and the chart now also mounts an `emptyDir` at `/var/cache/fontconfig`, which paperless-ngx 3.0 expects to be writable.

### Application changes the chart cannot handle for you

- **The search index is rebuilt from scratch on first start** (Whoosh was replaced with Tantivy). This happens automatically, but it is CPU-heavy on large document sets and readiness may flap while it runs.
- **All task history is dropped** during the database migration.
- **Fulltext search syntax changed**: `note:` became `notes.note:` and `custom_field:` became `custom_fields.value:`. Saved views with an explicit field prefix are migrated automatically; plain unqualified queries that happened to match note or custom field content are not.
- **OIDC logins** may need `token_auth_method` added to the provider settings in the secret referenced by `auth.sso.providersSecret` if the callback starts failing with `invalid_client`.
- **Document and thumbnail encryption was removed.** If you ever enabled it, decrypt your documents with the `decrypt_documents` management command *before* upgrading.
- **Pre- and post-consume scripts** no longer receive positional arguments; use the `DOCUMENT_*` environment variables instead.
- The image now ships PyTorch regardless of whether the AI features are enabled, so expect a larger image and a higher memory floor.

## AI features

Paperless-ngx 3.0 added LLM-backed suggestions and optional retrieval augmented generation. Everything is off by default; set `ai.enabled` and pick a backend to turn it on.

> Your document content is sent to whichever backend you configure. Hosted providers may be paid services and you are responsible for any usage charges. Prefer a backend inside your own cluster if that matters to you.

`ai.backend` is required when `ai.enabled` is true and must be `openai-like` or `ollama`. The chart fails the render with a helpful message if it is missing or invalid, rather than letting the pod crash-loop on a startup error.

### Ollama running in the cluster

```yaml
ai:
  enabled: true
  backend: ollama
  endpoint: http://ollama.ai.svc.cluster.local:11434
  model: llama3.1
```

`ai.allowInternalEndpoints` must stay `true` for this, since paperless otherwise rejects endpoints that resolve to non-public addresses. It defaults to `true`.

### An OpenAI-compatible provider

```yaml
ai:
  enabled: true
  backend: openai-like
  model: gpt-4
  # Optional, to target a provider other than OpenAI
  endpoint: https://api.example.com/v1
  apiKeySecret:
    name: paperless-ai
    key: api-key
```

The API key is only read from a secret — create it yourself and reference it. There is no plain-value alternative, deliberately.

### RAG embeddings

Retrieval augmented features need an embedding backend on top of the above. It is configured separately because it does not have to be the same provider as the chat model:

```yaml
ai:
  embedding:
    backend: ollama       # or openai-like, huggingface
    model: embeddinggemma
```

The embedding index is written to `data/llm_index` inside the data volume, and `ai.embedding.indexCron` controls when embeddings for all documents are refreshed (daily at 02:10 by default).

The `huggingface` backend is different from the other two: it runs the embedding model **inside the paperless container** instead of calling out to a service. The chart points `HF_HOME` at the data volume for it, because the default cache location is the container home directory, which is neither writable under the chart's default `readOnlyRootFilesystem: true` nor persisted across restarts. Consequences worth planning for:

- The model is downloaded on first use, so the pod needs egress to huggingface.co and a few hundred MB to several GB of extra room in `persistence.data.size` (default `10Gi`).
- Inference happens in the paperless pod, so give it meaningfully more memory and CPU via `resources`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| ai | object | `{"allowInternalEndpoints":true,"apiKeySecret":{"key":null,"name":null},"backend":null,"contextSize":8192,"embedding":{"backend":null,"chunkSize":1024,"endpoint":null,"indexCron":"10 2 * * *","model":null},"enabled":false,"endpoint":null,"model":null,"outputLanguage":null,"requestTimeout":120}` | Settings for the AI features. Note that hosted providers may be paid services and that your document content is sent to whichever backend you configure. See: https://docs.paperless-ngx.com/configuration/#ai |
| ai.allowInternalEndpoints | bool | `true` | When set to false paperless blocks endpoint urls that resolve to non public addresses. Keep this enabled when the backend runs inside the cluster. |
| ai.apiKeySecret | object | `{"key":null,"name":null}` | Secret containing the api key for the backend. Typically required for `openai-like`, optional for others. |
| ai.apiKeySecret.key | string | `nil` | Key containing the api key |
| ai.apiKeySecret.name | string | `nil` | Name of the secret |
| ai.backend | string | `nil` | Backend to use for the LLM. Possible values are `openai-like` and `ollama`. Required when `ai.enabled` is true. |
| ai.contextSize | int | `8192` | Context size to use for prompts and RAG retrieval. Also sent as `num_ctx` to ollama backends. |
| ai.embedding | object | `{"backend":null,"chunkSize":1024,"endpoint":null,"indexCron":"10 2 * * *","model":null}` | Settings for the RAG embeddings. Only needed for the retrieval augmented features, the embedding index is stored in the data volume. |
| ai.embedding.backend | string | `nil` | Backend to use for embeddings. Possible values are `openai-like`, `huggingface` and `ollama`. When unset no embeddings are created. `huggingface` runs the model in the paperless container and downloads it into the data volume on first use. |
| ai.embedding.chunkSize | int | `1024` | Chunk size used when splitting document text for embeddings. Lower this when your backend rejects or truncates larger inputs. |
| ai.embedding.endpoint | string | `nil` | Endpoint of the embedding backend. Falls back to `ai.endpoint` when unset. |
| ai.embedding.indexCron | string | `"10 2 * * *"` | Cron expression for refreshing the embeddings of all documents. Only runs when `ai.enabled` and `ai.embedding.backend` are set. |
| ai.embedding.model | string | `nil` | Model to use for embeddings. Defaults to `text-embedding-3-small` for `openai-like`, `sentence-transformers/all-MiniLM-L6-v2` for `huggingface` and `embeddinggemma` for `ollama`. |
| ai.enabled | bool | `false` | Enables the AI features, including AI based suggestions. Required for any other setting in this block to take effect. |
| ai.endpoint | string | `nil` | Endpoint of the backend. Required for `ollama`, optional for `openai-like` to target a custom provider or local gateway. |
| ai.model | string | `nil` | Model to use for the backend. Defaults to `gpt-3.5-turbo` for `openai-like` and `llama3.1` for `ollama`. |
| ai.outputLanguage | string | `nil` | Language to use for AI suggestions. Defaults to the user's UI language when unset. |
| ai.requestTimeout | int | `120` | Timeout in seconds for requests to the backend. Increase this for slow or local inference servers. |
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
| database | object | `{"databaseName":null,"enableReadCache":false,"engine":"sqlite","host":null,"options":null,"password":null,"passwordSecret":{"key":null,"name":null},"port":null,"readCacheTTL":3600,"user":null,"userSecret":{"key":null,"name":null}}` | Database configuration |
| database.databaseName | string | `nil` | Can be used to configure a custom name for the database defaults to paperless |
| database.enableReadCache | bool | `false` | Caches the database read query results into Redis. This can significantly improve application response times by caching database queries, at the cost of slightly increased memory usage. |
| database.engine | string | `"sqlite"` | Engine to use for the database (possible values sqlite (default), postgresql, mariadb) |
| database.host | string | `nil` | When `engine` isn't sqlite set host for your database |
| database.options | string | `nil` | Advanced connection options as a comma-delimited key-value string (e.g. `sslmode=require,pool.max_size=10`). Dot-notation produces nested option dictionaries. Applies to all engines including sqlite. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_DB_OPTIONS |
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
| deploymentStrategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment strategy to use |
| documentConsumption | object | `{"dateOrder":"DMY","deleteDuplicates":false,"pollingInterval":0,"stabilityDelay":5}` | Settings to define how documents should be consumed by paperless |
| documentConsumption.dateOrder | string | `"DMY"` | Paperless will try to determine the document creation date from its contents. Specify the date format Paperless should expect to see within your documents. This option defaults to DMY which translates to day first, month second, and year last order. Characters D, M, or Y can be shuffled to meet the required order. |
| documentConsumption.deleteDuplicates | bool | `false` | Since paperless-ngx 3.0 duplicate documents are consumed and flagged in the UI. When enabled duplicates are instead deleted from the consume directory without being consumed. |
| documentConsumption.pollingInterval | int | `0` | How the consumer detects new files in the consume directory. `0` uses native filesystem notifications, a positive number polls the directory at that interval in seconds. Use polling when the consume volume is backed by a network filesystem (NFS, SMB/CIFS). |
| documentConsumption.stabilityDelay | int | `5` | Time in seconds a file must remain unchanged before paperless starts consuming it. Increase for slow storage or scanners that write incrementally. |
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
| hosting | object | `{"secretKey":{"create":true,"key":"key","name":null},"trustedClientIpHeader":null,"trustedProxies":[]}` | Settings pertaining to hosting |
| hosting.secretKey | object | `{"create":true,"key":"key","name":null}` | Paperless uses this to make session tokens. If you expose paperless on the internet, you need to change this, since the default secret is well known. |
| hosting.secretKey.create | bool | `true` | If set to true secret will be created on deploy. When false expects the secret to already exist |
| hosting.secretKey.key | string | `"key"` | Key of the secret |
| hosting.secretKey.name | string | `nil` | Name of the secret. Defaults to release name. |
| hosting.trustedClientIpHeader | string | `nil` | Header containing the real client IP for proxies that don't use `X-Forwarded-For` (e.g. `X-Real-IP`, `CF-Connecting-IP`). Takes precedence over `hosting.trustedProxies`. |
| hosting.trustedProxies | list | `[]` | IP addresses of reverse proxies that are allowed to set forwarding headers. Without this allauth cannot determine the client IP for login rate limiting when running behind an ingress or gateway, resulting in a 403 on login. |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"paperless-ngx/paperless-ngx","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secretes for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":30,"periodSeconds":100}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` |  |
| ocr | object | `{"archiveFileGeneration":"auto","cleanMode":"clean","colorConversionStrategy":null,"deskew":true,"imageDpi":null,"language":"eng","maxImagePixels":null,"mode":"auto","outputType":"pdfa","pageLimit":null,"rotatePages":true,"rotatePagesThreshold":12,"userArgs":null}` | Settings for ocr |
| ocr.archiveFileGeneration | string | `"auto"` | Controls when paperless creates a PDF/A archive version of your documents. Available modes are auto, always, never. `auto` skips the archive for born-digital PDFs that already contain text, `always` archives whenever the parser supports it. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_ARCHIVE_FILE_GENERATION for more info. |
| ocr.cleanMode | string | `"clean"` | Tells paperless to use unpaper to clean any input document before sending it to tesseract. Available modes: clean, clean-final, none |
| ocr.colorConversionStrategy | string | `nil` | Controls the Ghostscript color conversion strategy when creating the archive file. This setting will only be utilized if the output is a version of PDF/A. Valid options are: CMYK, Gray, LeaveColorUnchanged, RGB or UseDeviceIndependentColor |
| ocr.deskew | bool | `true` | Tells paperless to correct skewing (slight rotation of input images mainly due to improper scanning) |
| ocr.imageDpi | string | `nil` | Paperless will OCR any images you put into the system and convert them into PDF documents. This is useful if your scanner produces images. In order to do so, paperless needs to know the DPI of the image. Most images from scanners will have this information embedded and paperless will detect and use that information. In case this fails, it uses this value as a fallback. |
| ocr.language | string | `"eng"` | Customize the language that paperless will attempt to use when parsing documents. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_OCR_LANGUAGE for more info. |
| ocr.maxImagePixels | string | `nil` | Paperless will raise a warning when OCRing images which are over this limit and will not OCR images which are more than twice this limit. Note this does not prevent the document from being consumed, but could result in missing text content. |
| ocr.mode | string | `"auto"` | Tell paperless when and how to perform ocr on your documents. Four modes are available: auto, redo, force, off. See: https://docs.paperless-ngx.com/configuration/#PAPERLESS_OCR_MODE for more info. |
| ocr.outputType | string | `"pdfa"` | Specify the the type of PDF documents that paperless should produce. Available types: pdf, pdfa, pdf-1, pdf-2, pdf-3 |
| ocr.pageLimit | string | `nil` | Tells paperless to use only the specified amount of pages for OCR. Documents with less than the specified amount of pages get OCR'ed completely. |
| ocr.rotatePages | bool | `true` | Tells paperless to correct page rotation (90°, 180° and 270° rotation). |
| ocr.rotatePagesThreshold | int | `12` | Adjust the threshold for automatic page rotation by PAPERLESS_OCR_ROTATE_PAGES. This is an arbitrary value reported by tesseract. "15" is a very conservative value, whereas "2" is a very aggressive option and will often result in correctly rotated pages being rotated as well. |
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
| route | object | `{"additionalRules":[],"annotations":{},"enabled":false,"filters":[],"hostnames":[],"labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}` | This block is for setting up gateway api http route. More information can be found here: https://gateway-api.sigs.k8s.io/ |
| route.additionalRules | list | `[]` | Any custom rules you want to specify. Appended to the rules of the HTTPRoute. |
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
| tweaks | object | `{"apps":null,"timezone":"utc"}` | Various software tweaks for the paperless application |
| tweaks.apps | string | `nil` | A comma-separated list of Django apps to be included in Django's INSTALLED_APPS |
| tweaks.timezone | string | `"utc"` | Set the timezone |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
