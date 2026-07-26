{{/*
Expand the name of the chart.
*/}}
{{- define "audiobookshelf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "audiobookshelf.fullname" -}}
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
{{- define "audiobookshelf.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "audiobookshelf.labels" -}}
helm.sh/chart: {{ include "audiobookshelf.chart" . }}
{{ include "audiobookshelf.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "audiobookshelf.selectorLabels" -}}
app.kubernetes.io/name: {{ include "audiobookshelf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "audiobookshelf.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "audiobookshelf.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate the supplied values
*/}}
{{- define "audiobookshelf.validateValues" -}}
{{- if gt (int .Values.replicaCount) 1 }}
{{- fail (printf "replicaCount must be 0 or 1, got %d. Audiobookshelf stores its library, users and progress in a SQLite database on a single ReadWriteOnce volume; concurrent writers corrupt it." (int .Values.replicaCount)) }}
{{- end }}

{{/* SKIP_BINARIES_CHECK makes Audiobookshelf exit during startup unless both paths are set */}}
{{- if .Values.binaries.skipCheck }}
{{- range $field := list "ffmpegPath" "ffprobePath" }}
{{- if not (get $.Values.binaries $field) }}
{{- fail (printf "binaries.%s is required when binaries.skipCheck is true. Audiobookshelf exits during startup when the binary check is skipped without both paths set. In the upstream image they are /usr/bin/ffmpeg and /usr/bin/ffprobe." $field) }}
{{- end }}
{{- end }}
{{- end }}

{{/* The names double as volume names, so they must be unique and must not shadow the chart's own volumes */}}
{{- $reserved := list "tmp" "config" "metadata" }}
{{- $seen := dict }}
{{- range .Values.mediaMounts }}
{{- if has .name $reserved }}
{{- fail (printf "mediaMounts name %q is reserved by the chart. Pick another name; the mountPath is what libraries are added against." .name) }}
{{- end }}
{{- if hasKey $seen .name }}
{{- fail (printf "mediaMounts contains more than one entry named %q. Names double as volume names and have to be unique." .name) }}
{{- end }}
{{- $_ := set $seen .name true }}
{{- if and (not .existingClaim) (not .size) }}
{{- fail (printf "mediaMounts entry %q needs either existingClaim, to mount a volume you already have, or size, to have the chart provision one." .name) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the name for the config pvc
*/}}
{{- define "audiobookshelf.configPvcName" -}}
{{- printf "%s-config" (include "audiobookshelf.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name for the metadata pvc
*/}}
{{- define "audiobookshelf.metadataPvcName" -}}
{{- printf "%s-metadata" (include "audiobookshelf.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name for a media pvc. Takes a dict of `root` (the top level context) and `name`
(the mediaMounts entry name).
*/}}
{{- define "audiobookshelf.mediaPvcName" -}}
{{- printf "%s-%s" (include "audiobookshelf.fullname" .root) .name | trunc 63 | trimSuffix "-" }}
{{- end }}
