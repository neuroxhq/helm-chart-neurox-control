{{- define "neurox-control.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default .Chart.Name) . -}}
{{- end -}}

{{- define "neurox-control.useNeuroxDomain" -}}
  {{- if or (hasSuffix ".goneurox.com" .Values.global.domain) (hasSuffix ".goneuroxhq.com" .Values.global.domain) -}}
    "true"
  {{- end }}
{{- end }}

{{- define "neurox-control.apiImage" -}}
  {{ $apiImageVersion := include "neurox-control.subchartDetails.apiVersion" . }}
  {{- printf "%s/%s:%s" .Values.global.image.baseRegistry .Values.api.image.run.repository $apiImageVersion -}}
{{- end -}}

{{- define "neurox-control.host.all" }}
  {{- $hosts := list .Values.global.domain -}}
  {{- if .Values.global.vanityDomain -}}
    {{- $hosts = append $hosts .Values.global.vanityDomain -}}
  {{- end }}
  {{- join "," $hosts -}}
{{- end }}

{{- define "neurox-control.host.primary" }}
  {{- tpl (.Values.global.vanityDomain | default .Values.global.domain) . -}}
{{- end }}

{{- define "neurox-control.host.secondary" }}
  {{- $host := "" }}
  {{- if .Values.global.vanityDomain -}}
    {{- $host = .Values.global.domain -}}
  {{- end }}
  {{- tpl $host . -}}
{{- end }}

{{- define "neurox-control.idp.annotations" }}
  {{- tpl (.Values.idp.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end }}
{{- define "neurox-control.idp.image.init.pullPolicy" }}
  {{- tpl (.Values.idp.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end }}
{{- define "neurox-control.idp.image.run.pullPolicy" }}
  {{- tpl (.Values.idp.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end }}

{{- define "neurox-control.metrics.annotations" }}
  {{- tpl (.Values.metrics.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end }}

{{- define "neurox-control.redis.port" -}}
  {{- printf "6379" -}}
{{- end -}}
{{- define "neurox-control.redis.service" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- printf "%s.%s" $redisFullname $namespace -}}
{{- end -}}

{{- define "neurox-control.relay.annotations" }}
  {{- tpl (.Values.relay.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end }}
{{- define "neurox-control.relay.image.init.pullPolicy" }}
  {{- tpl (.Values.relay.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end }}
{{- define "neurox-control.relay.image.run.pullPolicy" }}
  {{- tpl (.Values.relay.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end }}

{{- define "neurox-control.sso.annotations" }}
  {{- tpl (.Values.sso.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end }}
{{- define "neurox-control.sso.image.pullPolicy" }}
  {{- tpl (.Values.sso.image.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end }}

{{- define "neurox-control.subchartDetails.apiVersion" -}}
  {{- range $.Chart.Dependencies }}
    {{- if eq .Name "api" }}
      {{- tpl .Version  . -}}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "neurox-control.subchartDetails.workload" -}}
  {{- range $.Chart.Dependencies }}
    {{- if eq .Name "workload" }}
      {{- printf "{\"name\":\"neurox-%s\",\"repository\":\"%s\",\"version\":\"%s\"}" .Name .Repository .Version }}
    {{- end }}
  {{- end }}
{{- end }}
