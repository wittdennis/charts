{{/*
Expand the name of the chart.
*/}}
{{- define "radicale.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "radicale.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "radicale.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "radicale.labels" -}}
helm.sh/chart: {{ include "radicale.chart" . }}
{{ include "radicale.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "radicale.selectorLabels" -}}
app.kubernetes.io/name: {{ include "radicale.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "radicale.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "radicale.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name for the data pvc
*/}}
{{- define "radicale.dataPvcName" -}}
{{- printf "%s-data" (include "radicale.fullname" .) }}
{{- end }}

{{/*
Create the name for the config Secret
*/}}
{{- define "radicale.configSecretName" -}}
{{- printf "%s-config" (include "radicale.fullname" .) }}
{{- end }}

{{/*
Port Radicale listens on inside the container. hosts binds to it, so it is the
single source of truth for the containerPort and the [server] hosts setting.
*/}}
{{- define "radicale.containerPort" -}}
5232
{{- end }}

{{/*
Mount path of the data volume. filesystem_folder lives underneath it, so it is
the single source of truth for the volumeMount and the [storage] setting.
*/}}
{{- define "radicale.dataMountPath" -}}
/var/lib/radicale
{{- end }}

{{/*
Path of the htpasswd users file the chart mounts for auth.type=htpasswd. The
[auth] htpasswd_filename setting is derived from it, so it always matches the mount.
*/}}
{{- define "radicale.authFilePath" -}}
/etc/radicale-auth/users
{{- end }}

{{/*
Path of the rights file the chart mounts for rights.type=from_file. The
[rights] file setting is derived from it, so it always matches the mount.
*/}}
{{- define "radicale.rightsFilePath" -}}
/etc/radicale-rights/rights
{{- end }}

{{/*
Fail fast on config that would produce a broken install.
*/}}
{{- define "radicale.validateConfig" -}}
{{- if eq .Values.config.auth.type "htpasswd" }}
{{- if and (not .Values.config.auth.htpasswd.users) (not .Values.config.auth.htpasswd.existingSecret) }}
{{- fail "config.auth.type is \"htpasswd\" but neither config.auth.htpasswd.users nor config.auth.htpasswd.existingSecret is set" }}
{{- end }}
{{- end }}
{{- if eq .Values.config.rights.type "from_file" }}
{{- if and (not .Values.config.rights.file.content) (not .Values.config.rights.file.existingSecret) }}
{{- fail "config.rights.type is \"from_file\" but neither config.rights.file.content nor config.rights.file.existingSecret is set" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Render the Radicale config file from the typed config values. Users never write
raw INI: internals that must match other chart resources ([server] hosts ->
containerPort, [storage] filesystem_folder -> data volume, the auth/rights file
paths -> mounts) are all managed here.
*/}}
{{- define "radicale.configContent" -}}
{{- include "radicale.validateConfig" . -}}
{{- $port := include "radicale.containerPort" . -}}
[server]
hosts = 0.0.0.0:{{ $port }}, [::]:{{ $port }}

[storage]
filesystem_folder = {{ include "radicale.dataMountPath" . }}/collections

[auth]
type = {{ .Values.config.auth.type }}
{{- if eq .Values.config.auth.type "htpasswd" }}
htpasswd_filename = {{ include "radicale.authFilePath" . }}
htpasswd_encryption = {{ if .Values.config.auth.htpasswd.existingSecret }}{{ .Values.config.auth.htpasswd.encryption }}{{ else }}plain{{ end }}
{{- end }}

[rights]
type = {{ .Values.config.rights.type }}
{{- if eq .Values.config.rights.type "from_file" }}
file = {{ include "radicale.rightsFilePath" . }}
{{- end }}

[web]
type = {{ if .Values.config.web.enabled }}internal{{ else }}none{{ end }}

[logging]
level = {{ .Values.config.logging.level }}
{{- with .Values.config.headers }}
{{- $headers := . }}

[headers]
{{- range $name := (keys . | sortAlpha) }}
{{ $name }} = {{ get $headers $name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Render the htpasswd file for inline users (plain encryption).
*/}}
{{- define "radicale.htpasswdContent" -}}
{{- range $user := (keys .Values.config.auth.htpasswd.users | sortAlpha) }}
{{ $user }}:{{ get $.Values.config.auth.htpasswd.users $user }}
{{- end }}
{{- end }}
