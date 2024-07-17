{{- define "env.db_creds" }}
env:
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.existingSecretName | default "db-user-pass" }}
      key: username
- name: DB_PASS
  valueFrom:
    secretKeyRef:
      name: {{ .Values.existingSecretName | default "db-user-pass" }}
      key: password
{{- end }}