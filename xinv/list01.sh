# Alle XRechnungen mit erfolgter Übergabe (transfered) und zugeordneter Belegnummer selektieren
QUERY="classifier == 'invoice' and state == 'transfered' and data.wcs.Belegnummer.exists()"

# Klassifizierung im Klartext anzeigen
# id und Objekttype mit auswählen
# max 10 Einträge
# Anzeige: id|letzte Änderung|status|Belegnummer|Rechnungsnummer|Dateigröße
# nach Änderungsdatum absteigend
# als Tabelle ausgeben
wdscli search -knl 10 -c "update state classifier data.wcs.Belegnummer data.wcs.Rechnungsnummer contentSize" -s "-update" -o table "${QUERY}"
