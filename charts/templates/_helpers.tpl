{{/*
Expand the name of the chart.
*/}}
{{- define "apex-dispatch-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "apex-dispatch-api.fullname" -}}
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
{{- define "apex-dispatch-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "apex-dispatch-api.labels" -}}
helm.sh/chart: {{ include "apex-dispatch-api.chart" . }}
{{ include "apex-dispatch-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "apex-dispatch-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "apex-dispatch-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Resolve the service account name.
*/}}
{{- define "apex-dispatch-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- if .Values.serviceAccount.name }}
{{- .Values.serviceAccount.name -}}
{{- else -}}
{{- include "apex-dispatch-api.fullname" . -}}
{{- end -}}
{{- else -}}
{{- if .Values.serviceAccount.existingName }}
{{- .Values.serviceAccount.existingName -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}
{{- end }}
