{{ define "tigerbeetle.hardcodedValues" -}}
# Set the nameOverride based on the release name if no override has been set
{{ if not .Values.global.nameOverride }}
global:
  nameOverride: "{{ .Release.Name }}"
{{ end }}

{{ if eq "statefulset" .Values.controllers.main.type }}
controllers:
  main:
    containers:
      main:
        args:
          - '--addresses={{ include "tigerbeetle.addresses" . }}'
          - "/data"
{{ end -}}
{{ end -}}

{{- define "tigerbeetle.addresses" -}}
{{- $replicas := .Values.controllers.main.replicas | int -}}
{{- $addresses := list -}}
{{- range $i := until $replicas -}}
    {{- $port := add 3001 $i -}}
    {{- $addresses = append $addresses (printf "0.0.0.0:%v" $port) -}}
{{- end -}}
{{- join "," $addresses -}}
{{- end -}}