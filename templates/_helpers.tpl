{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default "common-helm" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "common-helm" .Chart.Name .Values.nameOverride }}
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
{{- define "common.chart" -}}
{{- printf "%s-%s" (default "common-helm" .Chart.Name) (default "0.1.0" .Chart.Version) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . | default "common-helm-0.1.0" }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Check if a CRD exists
*/}}
{{- define "common.crd.exists" -}}
{{- $crd := . -}}
{{- $crdExists := lookup "apiextensions.k8s.io/v1" "CustomResourceDefinition" $crd "" -}}
{{- if not $crdExists }}
{{ fail (printf "The CRD %s does not exist. Please install it before proceeding." $crd) }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . | default "common-helm" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
App selector label
*/}}
{{- define "common.appSelectorLabel" -}}
app: {{ .name }}
{{- end }}

{{/*
Generate the name of the service account to use.
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .serviceAccount }}
{{- if .serviceAccount.name }}
{{- .serviceAccount.name }}
{{- else }}
{{- include "common.fullname" $ }}-{{ .name }}
{{- end }}
{{- else }}
{{- $.Values.common.serviceAccount | default "default" }}
{{- end }}
{{- end }}