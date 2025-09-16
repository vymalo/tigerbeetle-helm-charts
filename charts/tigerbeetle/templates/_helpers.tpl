{{ define "tigerbeetle.hardcodedValues" -}}
global:
# Set the nameOverride based on the release name if no override has been set
{{ if not $.Values.global.nameOverride }}
  nameOverride: "{{ .Release.Name }}"
{{ end }}

{{ if eq "statefulset" $.Values.controllers.main.type }}
controllers:
  main:
    initContainers:
      resolve-addresses:
        env:
          RAW_ADDRESSES: {{ include "tigerbeetle.addresses" . }}
{{ end -}}
configMaps:
  config:
    enabled: true
    data:
      REPLICA_COUNT: "{{ .Values.controllers.main.replicas }}"
{{ end -}}

{{- define "tigerbeetle.addresses" -}}
{{- $name := $.Release.Name -}}
{{- $fullname := include "bjw-s.common.lib.chart.names.fullname" $ -}}
{{- $port := (include "tigerbeetle.port" $) -}}
{{- $addresses := list -}}
{{- range $i := until (.Values.controllers.main.replicas | int) -}}
    {{- $addresses = append $addresses (printf "%s-%d.%s-headless:%v" $name $i $name $port) -}}
{{- end -}}
{{- join "," $addresses -}}
{{- end -}}

{{- define "tigerbeetle.port" -}}
{{- .Values.service.main.ports.http.port | int -}}
{{- end -}}
