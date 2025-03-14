{{- define "neurox-control-api.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-control-api") . -}}
{{- end -}}

{{- define "neurox-control-api.useNeuroxDomain" -}}
  {{- if or (hasSuffix ".goneurox.com" .Values.global.domain) (hasSuffix ".goneuroxhq.com" .Values.global.domain) -}}
    "true"
  {{- end -}}
{{- end -}}

{{- define "neurox-control-api.annotations" -}}
  {{- tpl (.Values.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end -}}

{{- define "neurox-control-api.chartConfigMap.name" -}}
    {{- printf "%s-%s" (.Values.global.fullnameOverride | default "neurox-control") .Values.global.chartConfigMap.nameSuffix -}}
{{- end -}}
{{- define "neurox-control-api.configConfigMap.name" -}}
    {{- printf "%s-%s" (.Values.global.fullnameOverride | default "neurox-control") .Values.global.configConfigMap.nameSuffix -}}
{{- end -}}

{{- define "neurox-control-api.host.all" -}}
  {{- $hosts := list .Values.global.domain -}}
  {{- if .Values.global.vanityDomain -}}
    {{- $hosts = append $hosts .Values.global.vanityDomain -}}
  {{- end -}}
  {{- join "," $hosts -}}
{{- end -}}
{{- define "neurox-control-api.host.primary" -}}
  {{- tpl (.Values.global.vanityDomain | default .Values.global.domain) . -}}
{{- end -}}

{{- define "neurox-control-api.idp.service" -}}
  {{- printf "%s-idp.%s" (.Values.global.fullnameOverride | default "neurox-control") .Release.Namespace -}}
{{- end -}}
{{- define "neurox-control-api.idp.port" -}}
  {{- printf "5557" -}}
{{- end -}}
{{- define "neurox-control-api.idp.host" -}}
  {{- $idpPort := include "neurox-control-api.idp.port" . -}}
  {{- $idpService := include "neurox-control-api.idp.service" . -}}
  {{- printf "%s:%s" $idpService $idpPort -}}
{{- end -}}

{{- define "neurox-control-api.image.init.pullPolicy" -}}
  {{- tpl (.Values.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-api.image.run.pullPolicy" -}}
  {{- tpl (.Values.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-api.image.run.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.run.repository -}}
{{- end -}}

{{- define "neurox-control-api.promUrl" -}}
  {{- $thanosPort := include "neurox-control-api.thanos.port" . -}}
  {{- $thanosService := include "neurox-control-api.thanos.service" . -}}
  {{- printf "http://%s:%s" $thanosService $thanosPort -}}
{{- end -}}
{{- define "neurox-control-api.thanos.port" -}}
  {{- printf "9090" -}}
{{- end -}}
{{- define "neurox-control-api.thanos.service" -}}
  {{- $thanosFullname := .Values.global.thanos.fullnameOverride}}
  {{- printf "%s-query.%s" $thanosFullname .Release.Namespace -}}
{{- end -}}

{{- define "neurox-control-api.redis.hosts" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- $hosts := list -}}
  {{- range $i := until 3 -}}
    {{- $fqdn := printf "%s-node-%d.%s-headless.%s" $redisFullname $i $redisFullname $namespace -}}
    {{- $hosts = append $hosts $fqdn -}}
  {{- end -}}
  {{- join "," $hosts -}}
{{- end -}}
{{- define "neurox-control-api.redis.port" -}}
  {{- printf "6379" -}}
{{- end -}}
{{- define "neurox-control-api.redis.service" -}}
  {{- $namespace := .Release.Namespace -}}
  {{- $redisFullname := .Values.global.redis.fullnameOverride -}}
  {{- printf "%s.%s" $redisFullname $namespace -}}
{{- end -}}

{{- define "neurox-control-api.relay.service" -}}
    {{- printf "%s-relay-server" (.Values.global.fullnameOverride | default "neurox-control") -}}
{{- end -}}
{{- define "neurox-control-api.relay.url" -}}
  {{- printf "http://%s.%s:%d" (include "neurox-control-api.relay.service" .) .Release.Namespace (.Values.global.relay.apiPort | int) -}}
{{- end -}}

{{- define "neurox-control-api.sso.headers" -}}
  {{- $claims := .Values.global.sso.claims -}}
  {{- $allClaims := list -}}
  {{- range $claims -}}
    {{- $allClaims = append $allClaims . -}}
  {{- end -}}
  {{- $headerPrefix := .Values.global.sso.headerPrefix -}}
  {{- $headers := list "x-vouch-success" "x-vouch-user" -}}
  {{- range $allClaims -}}
    {{- $sanitizedClaim := . | replace "_" "-" -}}
    {{- $prefixedClaim := printf "%s%s" $headerPrefix $sanitizedClaim -}}
    {{- $headers = append $headers $prefixedClaim -}}
  {{- end -}}
  {{- join "," $headers -}}
{{- end -}}


{{- define "neurox-control-api.tlsSecretName" -}}
  {{- tpl (.Values.ingress.tlsSecretName | default .Values.global.ingress.tlsSecretName) . -}}
{{- end -}}
