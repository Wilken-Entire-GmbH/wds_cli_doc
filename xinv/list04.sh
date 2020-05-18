# Die Importdatei, d.h. das XRechnungs XML selektieren. D.h. die Ursprungsversion
QUERY="classifier eq 'invoice' and state eq 'imported' and predVersion.exists(false)"

# über alle Versionen suchen 
# Klassifizierung im Klartext anzeigen
# id und Objekttype mit auswählen
# max 10 Einträge
# Anzeige: id|Typ|letzte Änderung|status|Klassifizierung|Mimetype|Dateigröße|Importpfad
# nach Änderungsdatum absteigend
# als Tabelle ausgeben
wdscli search -akn -l 10 -c "update state classifier contentType contentSize data.import.filename" -s -update -o table "${QUERY}"
