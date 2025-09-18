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
      zaddresses:
        env:
          SVC: "{{ $.Release.Name }}-headless"
          PORT: "{{ include "tigerbeetle.port" $ }}"
    containers:
      zwatcher:
        env:
          SVC: "{{ $.Release.Name }}-headless"
          PORT: "{{ include "tigerbeetle.port" $ }}"
{{ end -}}
configMaps:
  config:
    enabled: true
    data:
      REPLICA_COUNT: "{{ .Values.controllers.main.replicas }}"
{{ end -}}

{{- define "tigerbeetle.port" -}}
{{- .Values.service.main.ports.http.port | int -}}
{{- end -}}
