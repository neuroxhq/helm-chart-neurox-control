{{- define "neurox-workload-manager.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-workload-manager") . -}}
{{- end -}}

{{- define "neurox-workload-manager.apiUrl" -}}
  {{- $apiHost := .Values.api.host | default .Values.global.controlHost -}}
  {{- $apiProtocol := "https"}}
  {{- $apiPort := int .Values.api.port }}
  {{- if .Values.global.workloadCluster.local }}
    {{- $localApiServiceName := printf "%s-api" (.Values.global.fullnameOverride | default "neurox-control") }}
    {{- $apiHost = $apiHost | default (printf "%s.%s" $localApiServiceName .Release.Namespace) }}
    {{- $apiProtocol = "http" }}
    {{- if eq $apiPort 443 }}
      {{- $apiPort = 80 }}
    {{- end }}
  {{- end }}
  {{- printf "%s://%s:%d" $apiProtocol $apiHost $apiPort }}
{{- end -}}

{{- define "neurox-workload-manager.chartConfigMap.name" -}}
    {{- printf "neurox-workload-%s" .Values.global.chartConfigMap.nameSuffix -}}
{{- end -}}

{{- define "neurox-workload-manager.image.pullPolicy" -}}
  {{- tpl (.Values.image.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-workload-manager.image.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.repository -}}
{{- end -}}
