{{- define "neurox-workload.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-workload") . -}}
{{- end -}}

{{- define "neurox-workload.manager.service.name" -}}
  {{- $defaultworkloadManagerServiceName := .Values.manager.fullnameOverride | default "neurox-workload-manager" -}}
  {{- $workloadManagerServiceName := .Values.manager.fullnameOverride | default $defaultworkloadManagerServiceName -}}
  {{- printf "%s.%s" $workloadManagerServiceName .Release.Namespace -}}
{{- end -}}
{{- define "neurox-workload.manager.service.address" -}}
  {{- $workloadManagerService := include "neurox-workload.manager.service.name" . -}}
  {{- printf "%s:%d" $workloadManagerService (int .Values.manager.service.port) -}}
{{- end -}}

{{- define "neurox-workload.prometheus.remoteWriteUrl" }}
  {{- $remoteWriteHost := .Values.prometheus.remoteWrite.host | default .Values.global.controlHost -}}
  {{- $remoteWritePath := .Values.prometheus.remoteWrite.path }}
  {{- $remoteWritePort := .Values.prometheus.remoteWrite.port }}
  {{- $remoteWriteProtocol := "https"}}
  {{- if .Values.global.workloadCluster.local -}}
    {{- $defaultRemoteWriteHost := printf "neurox-control-thanos-receive.%s" .Release.Namespace }}
    {{- $remoteWriteHost = $remoteWriteHost | default $defaultRemoteWriteHost }}
    {{- $remoteWritePath = "/api/v1/receive" }}
    {{- if eq (int $remoteWritePort) 443 }}
      {{- $remoteWritePort = 19291 }}
      {{- $remoteWriteProtocol = "http"}}
    {{- end }}
  {{- end }}
  {{- printf "%s://%s:%d%s" $remoteWriteProtocol $remoteWriteHost (int $remoteWritePort) $remoteWritePath }}
{{- end }}
{{- define "neurox-workload.prometheus.metricFilter" -}}
  {{- $defaultMetrics := list
       "container_cpu_usage_seconds_total"
       "container_memory_usage_bytes"
       "kube_node_status_allocatable"
       "kube_pod_owner"
       "neurox_.*"
       "node_cpu_seconds_total"
       "node_memory_MemAvailable_bytes"
       "node_memory_MemTotal_bytes"
     -}}
  {{- $combined := concat $defaultMetrics .Values.prometheus.extraMetrics -}}
  {{- printf "^(%s)$" (join "|" $combined) -}}
{{- end -}}

{{- define "neurox-workload.relay.image.init.pullPolicy" -}}
  {{- tpl (.Values.relay.image.init.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-workload.relay.image.run.pullPolicy" -}}
  {{- tpl (.Values.relay.image.run.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-workload.relay.protocol" -}}
  {{- if .Values.global.workloadCluster.local }}"ws"{{- else }}"wss"{{- end -}}
{{- end -}}
{{- define "neurox-workload.relay.server.address"}}
  {{- $relayServerHost := .Values.relay.server.host | default .Values.global.controlHost -}}
  {{- $relayServerPort := int .Values.relay.server.port }}
  {{- if .Values.global.workloadCluster.local -}}
    {{- $localRelayServiceName := printf "%s-relay-server" (.Values.global.fullnameOverride | default "neurox-control") }}
    {{- $relayServerHost = $relayServerHost | default (printf "%s.%s" $localRelayServiceName .Release.Namespace) }}
    {{- if eq (int $relayServerPort) 443 }}
      {{- $relayServerPort = 8080 }}
    {{- end }}
  {{- end }}
  {{- printf "%s:%d" $relayServerHost $relayServerPort }}
{{- end }}
