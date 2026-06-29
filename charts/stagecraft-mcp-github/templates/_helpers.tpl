{{- define "stagecraft-mcp-github.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "stagecraft-mcp-github.selectorLabels" -}}
app.kubernetes.io/name: stagecraft-mcp-github
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
