{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "commonApp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for commonApp components
*/}}
{{- define "commonApp.common.matchLabels" -}}
app: {{ .Values.app.name }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "commonApp.common.metaLabels" -}}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
heritage: {{ .Release.Service }}
{{- end -}}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "commonApp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}


{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "commonApp.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{- define "commonApp.app.labels" -}}
{{ include "commonApp.app.matchLabels" . }}
{{ include "commonApp.common.metaLabels" . }}
{{- end -}}

{{- define "commonApp.app.matchLabels" -}}
component: {{ .Values.app.name | quote }}
{{ include "commonApp.common.matchLabels" . }}
{{- end -}}

{{/*
Create a fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "commonApp.app.fullname" -}}
    {{- if .Values.app.fullnameOverride -}}
        {{- .Values.app.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- .Release.Name -}}
    {{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the app component
*/}}
{{- define "commonApp.serviceAccountName.app" -}}
{{- if .Values.serviceAccounts.app.create -}}
    {{ default (include "commonApp.app.fullname" .) .Values.serviceAccounts.app.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.app.name }}
{{- end -}}
{{- end -}}


{{- define "commonApp.accounts.labels" -}}
{{ include "commonApp.accounts.matchLabels" . }}
{{ include "commonApp.common.metaLabels" . }}
{{- end -}}

{{- define "commonApp.accounts.matchLabels" -}}
component: {{ .Values.accounts.name | quote }}
{{ include "commonApp.common.matchLabels" . }}
{{- end -}}

{{/*
Create a fully qualified accounts name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "commonApp.accounts.fullname" -}}
{{- if .Values.accounts.fullnameOverride -}}
{{- .Values.accounts.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the accounts component
*/}}
{{- define "commonApp.serviceAccountName.accounts" -}}
{{- if .Values.serviceAccounts.accounts.create -}}
    {{ default (include "commonApp.accounts.fullname" . ) .Values.serviceAccounts.accounts.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.accounts.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the utils
*/}}


{{- define "commonApp.utils.labels" -}}
{{ include "commonApp.utils.matchLabels" . }}
{{ include "commonApp.common.metaLabels" . }}
{{- end -}}

{{- define "commonApp.utils.matchLabels" -}}
component: {{ .Values.utils.name | quote }}
{{ include "commonApp.common.matchLabels" . }}
{{- end -}}

{{/*
Create a fully qualified utils name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "commonApp.utils.fullname" -}}
{{- if .Values.utils.fullnameOverride -}}
{{- .Values.utils.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the utils component
*/}}
{{- define "commonApp.serviceAccountName.utils" -}}
{{- if .Values.serviceAccounts.utils -}}
{{- if .Values.serviceAccounts.utils.create -}}
    {{ default (include "commonApp.utils.fullname" .) .Values.serviceAccounts.utils.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.utils.name }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
    Second App configuration
*/}}

{{- define "commonApp.secondPartyApp.app" -}}
app: {{ .name }}
{{- end -}}

{{- define "commonApp.secondPartyApp.labels" -}}
{{ include "commonApp.secondPartyApp.matchLabels" . }}
{{ include "commonApp.common.metaLabels" . }}
{{- end -}}

{{- define "commonApp.secondPartyApp.matchLabels" -}}
component: {{ .Values.app.name | quote }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Create a fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{/*# {{- define "commonApp.secondPartyApp.fullname" -}}
# {{- if .fullnameOverride -}}
# {{- .fullnameOverride | trunc 63 | trimSuffix "-" -}}
# {{- else -}}
# {{- $name := default .Values.nameOverride -}}
# {{- if contains $name .Release.Name -}}
# {{- printf "%s-%s-%s" .Release.Namespace .Release.Name .Values.app.name | trunc 63 | trimSuffix "-" -}}
# {{- else -}}
# {{- printf "%s-%s-%s-%s" .Release.Namespace .Release.Name $name .Values.app.name | trunc 63 | trimSuffix "-" -}}
# {{- end -}}
# {{- end -}}
# {{- end -}}
*/}}

{{- define "commonApp.secondPartyApp.fullname" -}}
    {{- if .fullnameOverride -}}
        {{- .fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- .Release.Name -}}
    {{- end -}}
{{- end -}}


{{- define "commonApp.serviceAccountName.secondPartyApp" -}}
{{- if .Values.serviceAccounts.app.create -}}
    {{ default (include "commonApp.secondPartyApp.fullname" . ) .Values.serviceAccounts.app.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.app.name }}
{{- end -}}
{{- end -}}


