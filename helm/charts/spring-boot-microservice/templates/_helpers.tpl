{{/*
Common labels that are applied to all resources managed by this chart.
Uses the serviceName value for the app.kubernetes.io/name label.
*/}}
{{- define "spring-boot-microservice.labels" -}}
helm.sh/chart: {{ include "spring-boot-microservice.chart" . }}
{{ include "spring-boot-microservice.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels that are used by Deployments and Services to select matching Pods.
Uses the serviceName value for the app.kubernetes.io/name label.
Uses the Helm release name for app.kubernetes.io/instance to help isolate different installations.
*/}}
{{- define "spring-boot-microservice.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.serviceName | required ".Values.serviceName is required" }} # Ensure serviceName is provided
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spring-boot-microservice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 -}}
{{- end -}}

{{/*
Expand the name of the chart. Used as a base name in some templates.
*/}}
{{- define "spring-boot-microservice.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.serviceName -}} # Use serviceName as a base
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 -}}
{{- end -}}
{{- end -}}
{{- end -}}