{{/*
Expand the name of the chart.
*/}}
{{- define "shopinvader.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shopinvader.fullname" -}}
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
{{- define "shopinvader.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shopinvader.labels" -}}
helm.sh/chart: {{ include "shopinvader.chart" . }}
{{ include "shopinvader.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: shopinvader
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shopinvader.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shopinvader.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: shopinvader
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "shopinvader.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shopinvader.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
