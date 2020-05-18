# Die XRechnungskonfiguration im P5 DMS anzeigen
# Alle Einträge die nicht vom Typ Dokument sind (hier Classifier und Provider)
QUERY="objectType != 'Document'"

# suche ausführen, 
# dann Einträge ermitteln und im yaml Format ausgeben
wdscli search "${QUERY}" | wdscli get --stdin -o yaml
