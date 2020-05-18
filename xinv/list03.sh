# XRechnungen ohne erfolgte Übergabe an die CS/2
# Diese XRechnungen sind in der Verarbeitung und können evtl. nicht übergeben werden.
QUERY="classifier == 'invoice' and state in ['imported', 'extracted']"

# Klassifizierung im Klartext anzeigen
# id und Objekttype mit auswählen
# max 10 Einträge
# Anzeige: id|Typ|letzte Änderung|status|Klassifizierung|Mimetype|Dateigröße|Importpfad
# nach Änderungsdatum absteigend
# als Tabelle ausgeben
wdscli search -knl 10 -c "update state classifier contentType contentSize data.import.filename" -s -update -o table "${QUERY}"
