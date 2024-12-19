{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}

{{- define "hedgedoc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hedgedoc.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hedgedoc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create image name and tag used by the deployment.
*/}}
{{- define "hedgedoc.image" -}}
{{- $fullOverride := .Values.image.fullOverride | default "" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $separator := ":" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString -}}
{{- $variant := ternary "" (printf "-%s" .Values.image.variant) (not .Values.image.variant) -}}
{{- $digest := "" -}}
{{- if .Values.image.digest }}
    {{- $digest = (printf "@%s" (.Values.image.digest | toString)) -}}
{{- end -}}
{{- if $fullOverride }}
    {{- printf "%s" $fullOverride -}}
{{- else if $registry }}
    {{- printf "%s/%s%s%s%s%s" $registry $repository $separator $tag $variant $digest -}}
{{- else -}}
    {{- printf "%s%s%s%s%s" $repository $separator $tag $variant $digest -}}
{{- end -}}
{{- end -}}

{{/*
Docker Image Registry Secret Names evaluating values as templates
*/}}
{{- define "hedgedoc.images.pullSecrets" -}}
{{- $pullSecrets := .Values.imagePullSecrets -}}
{{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets (dict "name" .) -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
{{ toYaml $pullSecrets }}
{{- end }}
{{- end -}}


{{/*
Storage Class
*/}}
{{- define "hedgedoc.persistence.storageClass" -}}
{{- $storageClass :=  (tpl ( default "" .Values.persistence.storageClass) .) | default (tpl ( default "" .Values.global.storageClass) .) }}
{{- if $storageClass }}
storageClassName: {{ $storageClass | quote }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hedgedoc.labels" -}}
helm.sh/chart: {{ include "hedgedoc.chart" . }}
app: {{ include "hedgedoc.name" . }}
{{ include "hedgedoc.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hedgedoc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hedgedoc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "postgresql-ha.dns" -}}
{{- if (index .Values "postgresql-ha").enabled -}}
{{- printf "%s-postgresql-ha-pgpool.%s.svc.%s:%g" .Release.Name .Release.Namespace .Values.clusterDomain (index .Values "postgresql-ha" "service" "ports" "postgresql") -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.dns" -}}
{{- if (index .Values "postgresql").enabled -}}
{{- printf "%s-postgresql.%s.svc.%s:%g" .Release.Name .Release.Namespace .Values.clusterDomain .Values.postgresql.global.postgresql.service.ports.postgresql -}}
{{- end -}}
{{- end -}}

{{- define "hedgedoc.config.init" -}}
  {{- /*assert that only one PG dep is enabled */ -}}
  {{- if and (.Values.postgresql.enabled) (index .Values "postgresql-ha" "enabled") -}}
    {{- fail "Only one of postgresql or postgresql-ha can be enabled at the same time." -}}
  {{- end }}
  {{- if not (.Values.hedgedoc.config.dbURL) -}}
    {{- if (index .Values "postgresql-ha" "enabled") -}}
      {{- $_ := set .Values.hedgedoc.config "dbURL" (printf "postgres://%s:%s@%s/%s"
                                              (index .Values "postgresql-ha" "global" "postgresql" "username")
                                              (index .Values "postgresql-ha" "global" "postgresql" "password")
                                              (include "postgresql-ha.dns" .)
                                              (index .Values "postgresql-ha" "global" "postgresql" "database")) -}}
    {{- end -}}
    {{- if (index .Values "postgresql" "enabled") -}}
      {{- $_ := set .Values.hedgedoc.config "dbURL" (printf "postgres://%s:%s@%s/%s"
                                              (index .Values "postgresql" "global" "postgresql" "auth" "username")
                                              (index .Values "postgresql" "global" "postgresql" "auth" "password")
                                              (include "postgresql.dns" .)
                                              (index .Values "postgresql" "global" "postgresql" "auth" "database")) -}}
    {{- end -}}
  {{- end -}}
  {{- if and (eq .Values.hedgedoc.config.imageUploadType "filesystem") (not .Values.hedgedoc.config.uploadsPath) -}}
    {{- $_ := set .Values.hedgedoc.config "uploadsPath" "/data" -}}
  {{- end -}}
{{- end -}}

{{- define "hedgedoc.container-additional-mounts" -}}
  {{- if gt (len .Values.extraContainerVolumeMounts) 0 -}}
    {{- toYaml .Values.extraContainerVolumeMounts -}}
  {{- end -}}
{{- end -}}

{{- define "hedgedoc.serviceAccountName" -}}
{{ .Values.serviceAccount.name | default (include "hedgedoc.fullname" .) }}
{{- end -}}

{{/* Create a functioning probe object for rendering. Given argument must be either a livenessProbe, readinessProbe, or startupProbe */}}
{{- define "hedgedoc.deployment.probe" -}}
  {{- $probe := unset . "enabled" -}}
  {{- $probeKeys := keys $probe -}}
  {{- $containsMethod := false -}}
  {{- $methods := list "exec" "tcpSocket" "grpc" "httpGet" -}}
  {{- range $probeKeys -}}
    {{- if has . $methods -}}
      {{- $containsMethod = true -}}
    {{- end -}}
  {{- end -}}
  {{- if not $containsMethod -}}
    {{- $probe := set $probe "httpGet" (dict "path" "/_health" "port" "http") -}}
  {{- end -}}
  {{- toYaml $probe -}}
{{- end -}}
