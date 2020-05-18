# P5 DMS Command Line Interface

Das *P5 DMS Command Line Interface* kurz *wdscli*, ist  ein kommandzeilenorientieres Werkzeug zur Ausführung von Operationen in Verbindung mit dem P5 DMS auf Shellebene.  Komplexe Operationen sind durch die Aneinanderkettung der Befehle und in Kombination mit anderen Kommandozeilen Werkzeugen realisierbar. Systemadministratoren ermöglicht es auf einfache Art und Weise DMS Inhalte zu ermitteln, zu visualisieren und weiter zu verarbeiten.

# Praxisbeispiele anhand der XRechnungsverarbeitung
## Rechnungen auflisten 
* [Die letzten 10 mit einer Belegnummer versehenen XRechnungen auflisten.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/list01.sh)
* [Alle in der CSE noch nicht bearbeitete XRechnungen anzeigen.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/list02.sh)
* [Alle XRechnungen ohne erfolgte Übergabe in die CSE.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/list03.sh)
* [Die importierten XML Dateien der letzen 10 Rechnungen anzeigen.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/list04.sh)
## Metadaten anzeigen
* [Konfigurationsobjekte der XRechnung anzeigen.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/showconfig.sh)
* [Metadaten der letzten XRechnung anzeigen.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/showlast.sh)
## Rechnungsinhalte exportieren
* [Die XML-Dateien der letzten 3 XRechnungen exportieren.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/contentxml.sh)
* [Das Rechnungs-PDF der letzen 3 XRechungen mit der Belegnummer als Dateinamen exportieren.](https://github.com/wilken-entire-gmbh/wds_cli_doc/xinv/contentbooked.sh)

- [P5 DMS Command Line Interface](P5-DMS-Command-Line-Interface)
  - [Global](#global)
  - [Installation und Verbindungsparameter](#installation-und-verbindungsparameter)
    - [Hilfe](#hilfe)
    - [Erweiterte Ausgaben](#erweiterte-ausgaben)
- [Konzepte](#konzepte)
  - [Optionen](#optionen)
  - [Verkettung von Befehlen](#verkettung-von-befehlen)
  - [Formate](#formate)
- [Befehle](#befehle)
  - [Suche](#suche)
    - [Suchoptionen](#suchoptionen)
  - [Metadaten ermittlen](#metadaten-ermitteln)
    - [Ermittlungsoptionen](#ermittlungsoptionen)
  - [Inhalte herunterladen](#inhalte-herunterladen)
    - [Downloadoptionen](#downloadoptionen)

# Globale Optionen
```console
$ ./wdscli help
Usage: wdscli [options] [command]

Wilken P5 DMS Command Line Interface

Options:
  -V, --version                 output the version number
  -h, --host <host>             retrieval host
  -p, --port <port>             retrieval port
  --verbose                     show processing messages (default: false)
  --help                        display help for command

Commands:
  search [options] [query]      search for wds retrieval items. if wether [query] nor -s option is set <objectType eq "Documents"> will be executed.
  getContent [options] [id...]  get document content for given document id
  get [options] [id...]         get data for given document id
  help [command]                display help for command

```
## Installation und Verbindungsparameter
Das *wdscli* besteht aus einer ausführbaren Datei und wird für P5 DMS Versionen <= 1.0.4 unter */usr/bin* installiert. Für alle neueren Versionen befindet sich die Datei unter $WDS_ROOT/bin. Die Verwendung von *--host*/*--port* ist nicht notwendig, da über die Serverkonfiguration die Verbindungsparameter automatisch ermittelt werden.

Die Ermittlung ist versionabhängig:

P5 DMS Version | Ermittlung über
-|-
<= 1.04  | *~.wds/wds.env*    
\> 1.04  | *$WDS_CONFIG_DIR/default.yaml*


Auf allen Systemen ohne P5 DMS Installation kann die Datei nach eigener Wahl abgelegt werden. Zur Herstellung der Verbindung zum DMS Server sind die Verbindungsoptionen *--host*/*--port* dann initial zwingend. Beim ersten Aufruf wird unter dem Heimatverzeichnis des Benuters die Datei *.wdscli.rc* angelegt und die Werte eingetragen. Für jeden weiteren Aufruf werden die Verbindungsparameter aus dieser Datei gezogen. Bei Bedarf oder falsch eingebenen Parametern, werden die Verbindungsparameter einfach erneut eingegeben und dadurch in der *.wdscli.rc* überschrieben.

### Hilfe
Über die Optionen *-h* und *--help* oder dem Kommando `help` wird der Hilfetext ausgegeben. Durch Kombination dieser Optionen mit einem Kommando wird die Hilfe für das jeweilige Kommando ausgeben.

Beispiel für `get`:
```console
$ wdscli get --help
Usage: wdscli get [options] [id...]

get data for given document id

Options:
  --stdin                      read input from stdin (default: false)
  -i, --input <inputformat>    input format from stdin (json|ndjson|csv|id) (default: "id")
  -t, --type <objecttype>      the object type (Document|Classifier|Provider|Pool|Rule|Settings|Data) (default: "Document")
  -n, --byname                 resolve name on references instead of ids (default: false)
  -o, --output <outputformat>  output format (json|yaml|ndjson|csv|table|id) (default: "json")
  -h, --help                   display help for command
```
## Erweitere Ausgaben
Im Standard werden nur Fehlermeldungen ausgegeben. Durch Verwendung der Option *--verbose* werden Verarbeitungsmeldungen sichtbar gemacht. Die Ausgabe der Meldungen erfolgt immer über *stderr*, da *stdout* für die Inhalte verwendet wird.

# Konzepte

## Optionen
Für die meisten Optionen steht eine lange und kurze Notation zur Verfügung. Optionen in Kurzform werden in der Form *-[a-zA-Z]* angegeben, während die Langform durch *--[a-zA-Z]+* erfolgt. Befehle in Kurzform ohne folgenden Parameter können zusammengefasst werden.

Folgende Beispiele haben dieselbe Bedeutung und unterscheiden sich nur durch die Schreibweise:

lange Schreibweise:

```console
$ wdscli search --keys --byname --all --limit 2 --col "title contentSize" --output table  "objectType eq 'Document and title !=''"
```
kurze Schreibweise:
```console
$ wdscli search -k -n -a -l 2 -c "title contentSize" -o table  "objectType eq 'Document' and title != ''"
```
kurze Schreibweise mit zusammengefassten Optionen:
```console
$ wdscli search -knal 2 -c "title contentSize" -o table  "objectType eq 'Document' and title != ''"
```
Das Ergebnis für alle drei Eingaben:
```console
┌─────────┬────────────────────────────────────────┬────────────┬────────────────────────────────┬─────────────┐
│ (index) │                   id                   │ objectType │             title              │ contentSize │
├─────────┼────────────────────────────────────────┼────────────┼────────────────────────────────┼─────────────┤
│    0    │ '81886c7b-b1a0-435d-a649-fa5dc119c534' │ 'Document' │      '20190807_Test1.pdf'      │    30291    │
│    1    │ 'e27eb6c2-b7aa-407d-8418-34159e6f597f' │ 'Document' │ 'Technisches Eingangsdokument' │    69313    │
└─────────┴────────────────────────────────────────┴────────────┴────────────────────────────────┴─────────────┘
```

## Verkettung von Befehlen
Ein wesentliches Konzept von Windows- und Unixshells sind [Pipes](https://de.wikipedia.org/wiki/Pipe_(Informatik)). Befehle werden dabei auf Shell Ebene über das Pipe Symbol *'|'* miteinander verkettet.

Dabei führen einzelne Befehle spezialisierte Aufgaben aus und geben das Kommando an den nächsten Befehl weiter.

Damit *wdscli* Befehle die Eingabe aus *stdin* entgegen nehmen, muss die Option *--stdin* verwendet werden. Ansonsten wird die Eingabe als Parameter am Ende des Befehls erwartet.

Eingabe des Queries als Parameter:
```console
$ wdscli search --stdin -c "id name createdate" -o table "objectType in ['Classifier','Provider']"
```
Eingabe durch Verkettung:
```console
$ echo "objectType in ['Classifier','Provider']" | wdscli search --stdin -c "id name createdate" -o table
```

Beide Eingaben liefern dasselbe Ergebnis:
```console
┌─────────┬────────────────────────────────────────┬───────────┬────────────────────────────┐
│ (index) │                   id                   │   name    │         createdate         │
├─────────┼────────────────────────────────────────┼───────────┼────────────────────────────┤
│    0    │ '7a807ee8-3019-48c8-ae1e-0a609307a84e' │ 'invoice' │ '2019-11-11T15:16:01.827Z' │
│    1    │ 'aea435f1-19cf-4089-9b17-08bd852dca6e' │  'nosql'  │ '2019-11-11T15:16:01.801Z' │
└─────────┴────────────────────────────────────────┴───────────┴────────────────────────────┘
```
Noch eine Beispiel: Suche nach *Storage Provider* und Ausgabe der Metadaten
```console
$ echo "objectType == 'Provider'" | wdscli search --stdin | wdscli get --stdin -o yaml
```
Es geht auch einfacher bei Kenntnis des Namens:
```console
$ wdscli get -t Classifier -o yaml nosql
```
Ergebnis für beide Eingaben:

```console
- id: aea435f1-19cf-4089-9b17-08bd852dca6e
  version: 0
  objectType: Provider
  createdate: '2019-11-11T15:16:01.801Z'
  update: '2019-11-11T15:16:01.801Z'
  name: nosql
  config:
    type: NoSqlProvider
    options:
      collection: invoices
  dataTemplates: []
```
## Formate
Für die Ausgabe und den Transport von Daten stehen verschiedene Formate zur Auswahl. Das Ausgabeformat wird über *-o, --output \<format>*, bei Verkettungen das Eingabeformat über *-i, --input \<format>* festgelegt. Werden diese Optionen weggelassen, wird als Standard das *id* Format verwendet.

### id
Das *id* Format ist das Standardformat für die Daten Ein- und Ausgabe. Das Format besteht aus der technischen Id (UUID/4) und dem Objekttyp eines Archiveintrages, getrennt durch ein Leerzeichen. Diese Daten beschreiben einen Archiveintrag eindeutig und sind die minimal benötigte Information bei Verkettungen.

```console
$ wdscli search  "objectType nin ['Document']"
3c66b847-146a-4240-996a-84b2ce12fcf3 Settings
7a807ee8-3019-48c8-ae1e-0a609307a84e Classifier
aea435f1-19cf-4089-9b17-08bd852dca6e Provider
```
### csv
Die Ausgabe erfolgt im [*CSV* Format](https://de.wikipedia.org/wiki/CSV_(Dateiformat)). Als Trennzeichen wird ein Semikolon verwendet. Für die UTF-8 Erkennung z.B. von älteren Excel Versionen wird am Anfang der Ausgabe ein [*BOM*](https://de.wikipedia.org/wiki/Byte_Order_Mark) geschrieben.

```console
$ wdscli search -c "id name createdate" -o csv "objectType nin ['Document']"
﻿id;name;createdate
3c66b847-146a-4240-996a-84b2ce12fcf3;default;2019-11-11T15:16:01.847Z
7a807ee8-3019-48c8-ae1e-0a609307a84e;invoice;2019-11-11T15:16:01.827Z
aea435f1-19cf-4089-9b17-08bd852dca6e;nosql;2019-11-11T15:16:01.801Z
```

### json
Die Ausgabe erfolgt im [*JSON* Format](https://de.wikipedia.org/wiki/JavaScript_Object_Notation), dem Standardformat von Javascript und den meisten Webanwendungen.

```console
$ wdscli search -c "id name createdate" -o json "objectType nin ['Document']"
[
{"id":"3c66b847-146a-4240-996a-84b2ce12fcf3","name":"default","createdate":"2019-11-11T15:16:01.847Z"},
{
  "id": "7a807ee8-3019-48c8-ae1e-0a609307a84e",
  "name": "invoice",
  "createdate": "2019-11-11T15:16:01.827Z"
},
{
  "id": "aea435f1-19cf-4089-9b17-08bd852dca6e",
  "name": "nosql",
  "createdate": "2019-11-11T15:16:01.801Z"
}
]
```

### ndjson
Die Ausgabe erfolgt im [*NDJSON* Format](https://de.wikipedia.org/wiki/JSON_streaming#Line-delimited_JSON). Dieses Format wird von vielen modernen Anwendungen verwendet um große Datenmengen zu streamen.
```console
$ wdscli search -c "id name createdate" -o ndjson "objectType nin ['Document']"
{"id":"3c66b847-146a-4240-996a-84b2ce12fcf3","name":"default","createdate":"2019-11-11T15:16:01.847Z"}
{"id":"7a807ee8-3019-48c8-ae1e-0a609307a84e","name":"invoice","createdate":"2019-11-11T15:16:01.827Z"}
{"id":"aea435f1-19cf-4089-9b17-08bd852dca6e","name":"nosql","createdate":"2019-11-11T15:16:01.801Z"}
```

### yaml
Die Ausgabe erfolt im [*YAML* Format](https://de.wikipedia.org/wiki/YAML). *YAML* ist das für Menschen am besten lesbare Format und wird im P5 DMS als Standardformat für alle Konfigurationsdateien verwendet.

```console
$ wdscli search -c "id name createdate" -o yaml "objectType nin ['Document']"
- id: 3c66b847-146a-4240-996a-84b2ce12fcf3
  name: default
  createdate: '2019-11-11T15:16:01.847Z'
- id: 7a807ee8-3019-48c8-ae1e-0a609307a84e
  name: invoice
  createdate: '2019-11-11T15:16:01.827Z'
- id: aea435f1-19cf-4089-9b17-08bd852dca6e
  name: nosql
  createdate: '2019-11-11T15:16:01.801Z'
```

### table
Die Ausgabe erfolt im *TABLE* Format. Diese Format ist für Listenausgaben in einer Shell optimiert.

```console
$ wdscli search -c "id name createdate" -o table "objectType nin ['Document']"
┌─────────┬────────────────────────────────────────┬───────────┬────────────────────────────┐
│ (index) │                   id                   │   name    │         createdate         │
├─────────┼────────────────────────────────────────┼───────────┼────────────────────────────┤
│    0    │ '3c66b847-146a-4240-996a-84b2ce12fcf3' │ 'default' │ '2019-11-11T15:16:01.847Z' │
│    1    │ '7a807ee8-3019-48c8-ae1e-0a609307a84e' │ 'invoice' │ '2019-11-11T15:16:01.827Z' │
│    2    │ 'aea435f1-19cf-4089-9b17-08bd852dca6e' │  'nosql'  │ '2019-11-11T15:16:01.801Z' │
└─────────┴────────────────────────────────────────┴───────────┴────────────────────────────┘
```

# Befehle
## Suche
Der *search* Befehl ermöglicht Suchanfragen auf das Archiv. Die Suche wird über die *P5 DMS Abfragesprache* beschrieben.
```console
$ wdscli search --help
Usage: wdscli search [options] [query...]

search for wds retrieval items. if wether [query] nor -s option is set <objectType eq "Documents"> will be executed.

Options:
  -l, --limit <count>          limit result set size, -1 for all (default: 10)
  -c, --col <columns>          define projection by a space separated name string (default: "title createdate update classifier pool contentType contentSize")
  -k, --keys                   add primary keys (id, objectType) to output (default: false)
  -s, --sort <sortcolumns>     define sort order by a space separated name string. '-' as name prefix select descending order (default: "-createdate")
  -a, --all                    retrieve all versions (default: false)
  -n, --byname                 resolve name on references instead of ids (default: false)
  -r, --retrieve               retrieve search values from fulltext (default: false)
  -u, --viewer                 determine viewer for visualization (default: false)
  --stdin                      read query argument from stdin (default: false)
  -o, --output <outputformat>  output format (json|ndjson|csv|table|id) (default: "id")
  -h, --help                   display help for command
```

### Suchoptionen

* *--stdin*<br>
Die Parameter werden aus *stdin* gelesen. Diese Option ist bei der [Verkettung von Befehlen](#verkettung-von-befehlen) zwingend erforderlich.

* *-o, --output \<format>*<br>
Legt das Ausgabeformat fest. Siehe [Formate](*formate*)

* *-l, --limit \<count>* <br>
Limitiert die Ergebnismenge auf *\<count>* Zeilen. Bei einem Wert von -1 ist die Zeilenanzahl nur von der Anfrage abhängig. Die Voreinstellung ist 10.

* *-c,--col \<columns>*<br>
Spaltenauswahl. \<columns> besteht aus einer Aneinanderreihung von Feldnamen durch Leerzeichen getrennt. Die Voreinstellung wird beim Aufruf von *search --help* angezeigt. Bei Kombination mit dem *id* Format wird diese Option ignoriert.

* *-s, --sort \<columns>*<br>
Sortierreihenfolge. *\<columns>* besteht aus einer Aneinanderreihung von Feldnamen durch Leerzeichen getrennt. Die Voreinstellung pro Feld ist aufsteigend. Durch Angabe eines '-' vor dem Feldnamen wird die Sortierreihenfolger für das folgende Feld auf absteigend umgestellt. Die Voreinstellung wird beim Aufruf von *search --help* angezeigt.

* *-k, --keys*<br>
Fügt der Spaltenauswahl *id* und *objectType* hinzu.

* *-a, --all*<br>
Aktiviert die Suche über alle Versionen eines Dokumentes. Suchanfragen werden normalerweise nur auf die letzte Version eines Dokumentes ausgeführt. Durch Verwendung dieser Option erfolgt die Suche über alle Versionen.

* *-n, --byname*<br>
Für Dokumente. Referenzen von Classifier, Provider und Pool werden mit dem *name* angezeigt. Die Voreinstellung ist *id*

* *-r, --retrieve*<br>
Nur wirksam bei hinterlegten OCR Daten. Integriert den Text inklusive Seite und Postion in die Ergebnismenge, aufgrund dessen das Dokument gefunden wurde.

* *-u, --viewer*<br>
Für Dokumente. Integriert den Namen der Standardvisualisierung des *P5 UI Backends* in die Ergebnismenge.

## Metadaten ermitteln
Der *get* Befehl dient zur Ermittlung der Metadaten von Dokumenten und P5 DMS Konfigurationsobjekten. Die Ermittlung erfolgt unter Verwendung der Id und des Objekttyps.

Metadaten sind unterteilt in zwei Gruppen:

* **Systemdaten**<br>
Systemdaten beinhalten Informationen wie die Id, den Objektyp, das Anlagedatum oder den Status eines Dokumentes. Diese Informationen sind auf der obersten Ebene verfügbar

* **Anwendungsdaten**<br>
Anwendungsdaten werden während der Verarbeitung erzeugt. Diese Daten beinhalten z.B. Informationen über Import oder Übergabedaten an die Finanzbuchhaltung. Alle Anwendungsdaten sind unter dem Tag *data* verfügbar. 

```console
$ wdscli get --help
Usage: wdscli get [options] [id...]

get data for given document id

Options:
  --stdin                      read input from stdin (default: false)
  -i, --input <inputformat>    input format from stdin (json|ndjson|csv|id) (default: "id")
  -t, --type <objecttype>      the object type (Document|Classifier|Provider|Pool|Rule|Settings|Data) (default: "Document")
  -n, --byname                 resolve name on references instead of ids (default: false)
  -o, --output <outputformat>  output format (json|yaml|ndjson|csv|table|id) (default: "json")
  -h, --help                   display help for command
```
### Ermittlungsoptionen
* *--stdin*<br>
Die Parameter werden aus *stdin* gelesen. Diese Option ist bei der [Verkettung von Befehlen](#verkettung-von-befehlen) zwingend erforderlich.

* *-i, --input \<inputformat>*<br>
Legt das Eingabeformat fest. Siehe[Formate](*formate).

* *-o, --output \<outputformat>*<br>
Legt das Ausgabeformat fest. Siehe [Formate](*formate*)

* *-t, --type \<objectype>*<br>
Über *--type* wird der zu ermittelnde Objekttyp festgelegt. Bei Parameterübergabe ist diese Option zwingend erforderlich. Bei Verwendung von *--stdin* wird *objectType* über *stdin* gelesen.

* *-n, --byname*<br>
Für Dokumente. Referenzen von Classifier, Provider und Pool werden mit dem *name* angezeigt. Die Voreinstellung ist *id*

## Inhalte herunterladen
Der *getContent* Befehl speichert den Inhalt eines Archivdokuments in eine Datei. Über die *--loc* wird das Verzeichnis für die Speicherung festgelegt. Die Dokumentenid wird entweder als Parameter übergeben oder bei Verwendung von *--stdin* aus *stdin* gelesen. Da nur Dokumente einen Inhalt besitzen ist die Angabe des Objektyps nicht nötig. 

Als Dateinamen für die Ausgabe wird der im Archiv hinterlege Dateinamen vom Import des Dokumentes verwendet. Da diese Namen nicht eindeutig sind, werden bei der Ausgabe von mehreren Dokumenten, evtl. vorherige Ausgabe überschrieben. Durch die *--filename* Option können die Dateinamen selbst vergeben werden. 

```console
$ wdscli getContent --help
Usage: wdscli getContent [options] [idOrName...]

get document content for given document id

Options:
  --stdin                    read input from stdin (default: false)
  -i, --input <inputformat>  input format from stdin (json|ndjson|csv|id) (default: "id")
  -l, --loc <location>       location for file output. [C:\develop\node\pkg\wds\wds_cmdtools]
  -f, --filename <template>  build filename by given template.
  -t, --test                 only print complete file path via stderr (default: false)
  -h, --help                 display help for command
```

### Downloadoptionen
* *--stdin*<br>
Die Parameter werden aus *stdin* gelesen. Diese Option ist bei der [Verkettung von Befehlen](#verkettung-von-befehlen) zwingend erforderlich.

* *-i, --input \<inputformat>*<br>
Legt das Eingabeformat fest. Siehe[Formate](*formate).

* *-l, --loc \<location>*<br>
Legt das Ausgabeverzeichnis fest. Das Ausgabeverzeichnis wird nicht automatisch angelegt.

* *-f, --filename \<template>*<br>
Die *--filename* Option ermöglicht die indivduelle Festlegung der Ausgabedateinamen. *\<template>* dient dabei als Vorlage und kann mit Platzhaltern in der Syntax '{{platzhalter}}' versehen werden. Über '\_' als Platzhalter kann der ursprüngliche Dateinamen eingebracht werden.<br>
Beispiel: Dateinamen aus id und ursprünglichem Namen, getrennt durch einen Bindestrich erzeugen: "{{id}}-{{\_}}". Als Platzhalter können alle Daten verwendet werden, welche über *stdin* übergeben werden. Bei Aufruf über Parameter stehen nur die Platzhalter 'id' und '\_' zur Verfügung.

* *-t, --test*<br>
Durch *--test* erfolgt der Download ohne Speicherung. In Verbindung mit *--verbose* wird so das Herunterladen an den festgelegten Ort simuliert.

