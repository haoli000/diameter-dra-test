{{- define "diameter-dra.fullname" -}}
{{- printf "%s" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "diameter-dra.name" -}}
{{- printf "%s" .Chart.Name -}}
{{- end -}}