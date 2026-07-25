{{/*
Expand the name of the chart.
*/}}
{{- define "calibre-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "calibre-web.fullname" -}}
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
{{- define "calibre-web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "calibre-web.labels" -}}
helm.sh/chart: {{ include "calibre-web.chart" . }}
{{ include "calibre-web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "calibre-web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "calibre-web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "calibre-web.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "calibre-web.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate the supplied values
*/}}
{{- define "calibre-web.validateValues" -}}
{{- if gt (int .Values.replicaCount) 1 }}
{{- fail (printf "replicaCount must be 0 or 1, got %d. Calibre-Web stores its settings and the Calibre library in SQLite databases on a single ReadWriteOnce volume; concurrent writers corrupt them." (int .Values.replicaCount)) }}
{{- end }}
{{- end }}

{{/*
Create the name for the config pvc
*/}}
{{- define "calibre-web.configPvcName" -}}
{{- printf "%s-config" (include "calibre-web.fullname" .) }}
{{- end }}

{{/*
Create the name for the library (books) pvc
*/}}
{{- define "calibre-web.dataPvcName" -}}
{{- printf "%s-books" (include "calibre-web.fullname" .) }}
{{- end }}
