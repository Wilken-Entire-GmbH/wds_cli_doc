# Alle XRechnungen mit erfolgter Übergabe (transfered) und zugeordneter Belegnummer selektieren
QUERY="classifier == 'invoice' and state == 'transfered' and data.wcs.Belegnummer.exists()"

# suche nach XRechnungen, nach Anlagedatum absteigend, drei Rechnungen
# dann Einträge ermitteln und im ndjson Format weiterleiten,
# die Dateien herunterladen, dabei die Belegnummer als Dateinamen verwenden.
wdscli search -l 3 -s " -createdate" "${QUERY}" | wdscli get --stdin -o ndjson | wdscli getContent --stdin -i ndjson -f "{{data.wcs.Belegnummer}}"
