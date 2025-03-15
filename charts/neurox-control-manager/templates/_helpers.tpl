{{- define "neurox-control-manager.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-control-manager") . -}}
{{- end -}}

{{- define "neurox-control-manager.api.serviceName" -}}
  {{ $globalOverride := .Values.global.fullnameOverride | default "neurox-control" }}
  {{- tpl (.Values.api.serviceOverride.host | default (printf "%s-api" $globalOverride)) . }}
{{- end -}}

{{- define "neurox-control-manager.api.servicePort" -}}
  {{- tpl (.Values.api.serviceOverride.port | default "80") . -}}
{{- end }}

{{- define "neurox-control-manager.image.init.pullPolicy" -}}
  {{- tpl (.Values.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-manager.image.run.pullPolicy" -}}
  {{- tpl (.Values.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-manager.image.run.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.run.repository -}}
{{- end -}}

{{- define "neurox-control-manager.redis.hosts" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- $hosts := list -}}
  {{- range $i := until 3 -}}
    {{- $fqdn := printf "%s-node-%d.%s-headless.%s" $redisFullname $i $redisFullname $namespace -}}
    {{- $hosts = append $hosts $fqdn -}}
  {{- end -}}
  {{- join "," $hosts -}}
{{- end -}}

{{- define "neurox-control-manager.relay.serviceName" -}}
    {{- printf "%s-relay-server" (.Values.global.fullnameOverride | default "neurox-control") }}
{{- end }}
{{- define "neurox-control-manager.relay.url" -}}
  {{- printf "http://%s.%s:%d" (include "neurox-control-manager.relay.serviceName" .) .Release.Namespace (.Values.global.relay.apiPort | int) }}
{{- end }}

{{- define "neurox-control-manager.redis.port" -}}
  {{- printf "6379" -}}
{{- end -}}
{{- define "neurox-control-manager.redis.service" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- printf "%s.%s" $redisFullname $namespace -}}
{{- end -}}
