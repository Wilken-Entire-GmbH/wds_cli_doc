# Alle XRechnungen mit erfolgter Übergabe (transfered) und OHNE zugeordneter Belegnummer selektieren
# Übergeben und ohne Belegnummer bedeutet, dass die Rechnung noch nicht bearbeitet wurde.
QUERY="classifier == 'invoice' and state == 'transfered' and data.wcs.Belegnummer.exists(false)"

# Klassifizierung im Klartext anzeigen
# id und Objekttype mit auswählen
# komplett anzeigen
# Anzeige: id|letzte Änderung|status|Belegnummer|Rechnungsnummer|Dateigröße
# nach Änderungsdatum absteigend
# als Tabelle ausgeben
wdscli search -knl -1 -c "update state classifier data.wcs.Belegnummer data.wcs.Rechnungsnummer contentSize" -s -update -o table "${QUERY}"
