# Die Daten der zuletzt in CS/2 mit einer Buchungsnummer versehenen XRechnung anzeigen
# Eine XRechnung, die transferiert ist, mit einer zugeordneten Buchungsnummer
QUERY="classifier == 'invoice' and state == 'transfered' and data.wcs.Belegnummer.exists()"

# suche ausführen, nach Änderungsdatum absteigend, eine Rechnung 
# dann Einträge ermitteln und im yaml Format ausgeben
wdscli search -l 1 -s -update "${QUERY}" | wdscli get --stdin -o yaml
