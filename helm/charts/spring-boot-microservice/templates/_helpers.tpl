{{/*
Common labels for all resources.
*/}}
{{- define "spring-boot-microservice.labels" -}}
helm.sh/chart: {{ include "spring-boot-microservice.chart" . }}
{{ include "spring-boot-microservice.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels for Deployments and Services.
*/}}
{{- define "spring-boot-microservice.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.serviceName | required ".Values.serviceName is required" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Chart name and version for labels.
*/}}
{{- define "spring-boot-microservice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "spring-boot-microservice.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Full name for resources.
*/}}
{{- define "spring-boot-microservice.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.serviceName -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 -}}
{{- end -}}
{{- end -}}
{{- end -}}
