{{- define "neurox-control-portal.fullname" -}}
  {{- tpl (.Values.fullnameOverride | default "neurox-control-portal") . -}}
{{- end -}}

{{- define "neurox-control-portal.useNeuroxDomain" -}}
  {{- if or (hasSuffix ".goneurox.com" .Values.global.domain) (hasSuffix ".goneuroxhq.com" .Values.global.domain) -}}
    "true"
  {{- end -}}
{{- end -}}

{{- define "neurox-control-portal.annotations" -}}
  {{- tpl (.Values.ingress.annotations | default .Values.global.ingress.annotations | toYaml) . -}}
{{- end -}}

{{- define "neurox-control-portal.host.all" }}
  {{- $hosts := list .Values.global.domain -}}
  {{- if .Values.global.vanityDomain -}}
    {{- $hosts = append $hosts .Values.global.vanityDomain -}}
  {{- end }}
  {{- join "," $hosts -}}
{{- end }}

{{- define "neurox-control-portal.host.primary" }}
  {{- tpl (.Values.global.vanityDomain | default .Values.global.domain) . -}}
{{- end }}

{{- define "neurox-control-portal.image.pullPolicy" -}}
  {{- tpl (.Values.image.pullPolicy | default .Values.global.image.pullPolicy) . -}}
{{- end -}}
{{- define "neurox-control-portal.image.registry" -}}
  {{- printf "%s/%s" .Values.global.image.baseRegistry .Values.image.repository -}}
{{- end -}}

{{- define "neurox-control-portal.tlsSecretName" -}}
  {{- tpl (.Values.ingress.tlsSecretName | default .Values.global.ingress.tlsSecretName) . -}}
{{- end -}}
