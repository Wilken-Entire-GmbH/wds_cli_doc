# Die Daten der letzen 3 XRechnungen im Original Dateiformat herunterladen 
# Die erste Version einer XRechnung (predVersion(false) -> es ist die erste Version im Dokument)
QUERY="classifier == 'invoice' and state == 'imported' and predVersion.exists(false)"

# suche über alle Versionen ausführen, nach Anlagedatum absteigend, drei Rechnungen
# dann Einträge ermitteln und im ndjson Format weiterleiten,
# die Dateien herunterladen, dabei den Originaldateinamen verwenden
wdscli search -al 3 -s -createdate "${QUERY}" | wdscli get --stdin -o ndjson | wdscli getContent --stdin -i ndjson
