{{- define "app-of-apps.applicationName" -}}
{{- printf "%s" .name | trunc 63 | trimSuffix "-" }}
{{- end }}
