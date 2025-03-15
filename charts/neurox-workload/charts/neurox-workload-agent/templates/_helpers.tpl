{{- define "neurox-workload-agent.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-workload-agent") . -}}
{{- end -}}

{{- define "neurox-workload-agent.image.address" -}}
  {{- tpl (printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion)) . -}}
{{- end -}}
{{- define "neurox-workload-agent.image.pullPolicy" -}}
  {{- tpl (.Values.image.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-workload-agent.image.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.repository -}}
{{- end -}}
