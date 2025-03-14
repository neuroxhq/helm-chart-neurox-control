{{- define "neurox-control-scheduler.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-control-scheduler") . -}}
{{- end -}}

{{- define "neurox-control-scheduler.api.serviceName" -}}
  {{ $globalOverride := .Values.global.fullnameOverride | default "neurox-control" }}
  {{- tpl (.Values.api.serviceOverride.host | default (printf "%s-api" $globalOverride)) . }}
{{- end -}}

{{- define "neurox-control-scheduler.api.servicePort" -}}
  {{- tpl (.Values.api.serviceOverride.port | default "80") . -}}
{{- end }}

{{- define "neurox-control-scheduler.image.init.pullPolicy" -}}
  {{- tpl (.Values.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-scheduler.image.run.pullPolicy" -}}
  {{- tpl (.Values.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-scheduler.image.run.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.run.repository -}}
{{- end -}}

{{- define "neurox-control-scheduler.redis.hosts" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- $hosts := list -}}
  {{- range $i := until 3 -}}
    {{- $fqdn := printf "%s-node-%d.%s-headless.%s" $redisFullname $i $redisFullname $namespace -}}
    {{- $hosts = append $hosts $fqdn -}}
  {{- end -}}
  {{- join "," $hosts -}}
{{- end -}}

{{- define "neurox-control-scheduler.relay.serviceName" -}}
    {{- printf "%s-relay-server" (.Values.global.fullnameOverride | default "neurox-control") }}
{{- end }}
{{- define "neurox-control-scheduler.relay.url" -}}
  {{- printf "http://%s.%s:%d" (include "neurox-control-scheduler.relay.serviceName" .) .Release.Namespace (.Values.global.relay.apiPort | int) }}
{{- end }}

{{- define "neurox-control-scheduler.redis.port" -}}
  {{- printf "6379" -}}
{{- end -}}
{{- define "neurox-control-scheduler.redis.service" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- printf "%s.%s" $redisFullname $namespace -}}
{{- end -}}
