## Seite 1 – Anonymes Login (nur PW geschützt – ggf mit Gesichtserkennung oder Fingerabdruck)
- benötigte Sensoren
    - Gesichtserkennung (Kamera)
    - Fingerabdruck (Fingerabdruck Sensor)


## Seite 2 – Passwort Parameter Generator
- API PW Generator
    - https://qrng.anu.edu.au/contact/api-documentation/

## Seite 3 – (Opional) Generierte Passwörter LOKAL speichern (ggf. mit Notizen wo für)

- ListView

## Meilensteine 

<details><summary><h3>✔M1</h3></summary>
AF1 und AF2 sind erfüllt. Die Routen und die ListView/GridView müssen noch keine 
sinnvollen Daten beinhalten. 
</details>

<details><summary><h3>✔M2</h3></summary>
AF3 und AF4 sind erfüllt. Die App kann also Daten von einem Gerätesensor oder aus einer 
öffentlichen API darstellen und den authentifizierten Anwender erkennen. 
</details>

<details><summary><h3>M3</h3></summary>
Es wird die finale Version der App präsentiert, die alle oben genannten Anforderungen AF1-
5 erfüllt.
</details>

## main.dart
In dieser Datei befinden sich die Klassen, welche die Grundfunktionen der App beinhaltet.

<details>
<summary><h3>Klassen</h3></summary>
<details>
<summary>GeneratorEinstellungen</summary>
In der Klasse werden die Passwortparameter; die Länge des Passwortes sowie die Zeichengruppen; gesetzt 
sowie der Generator gestartet.
</details>
<details>
<summary>Settings</summary>
Diese Klasse beinhalten allgemeine Einstellungen, welche aktuell nur Platzhalter sind.
</details>
</details>

## firebase.dart
In dieser Datei befinden sich die Klassen, welche mit der Firebase kommunizieren.

<details>
<summary><h3>Übersicht</h3></summary>
<details>
<summary>Klassen</summary>
<details>
<summary>LoginPage</summary>
Hier kann sich der Nutzer einloggen sowie zu den Seiten "Regestrieren" oder "Passwort zurücksetzen" gelangen.
</details>
<details>
<summary>ForgotPassword</summary>
Hier kann der Nutzer sein Passwort zurücksetzen.
</details>
<details>
<summary>RegisterPage</summary>
In der Klasse wird ein neuer Benutzer angelegt.
</details>
<details>
<summary>DatenbankView</summary>
Auf dieser Seite werden die gespeicherten Passwörter abgerufen und angezeigt.
Der Nutzer kann von hier aus Passwörter kopieren sowie löschen.
</details>
</details>
<details>
<summary>Funktionen</summary>
<details>
<summary>_encpass</summary>
Diese Funktion wandelt das Klartext Passwort mithilfe des SHA512 Algorithmus um.
</details>
<details>
<summary>createcollection</summary>
Hier wird die Bezeichnung für eine Collection generiert, indem die Email sowie der SHA512-Hash des Passwortes konkatiniert wird und das Ergebnis mit dem MD5 Algorithmus verschlüsselt wird.
</details>
</details>
</details>

## crypto.dart
In dieser Datei wird das Passwort generiert.
<details>
<summary><h3>Funktionen</h3></summary>
<details>
<summary>Qrand</summary>
Diese Funktion gibt ein URL zurück, welcher die Länge des Passwortes enthält.
</details>
<details>
<summary>Gen_Password</summary>
In dieser Funktion werden zuerst die verbotenen Symbole definiert.
Im nächsten Schritt wird die Differenz dieser Menge und der Menge der erlaubten Symbole gebildet.
Damit es keine Zufallszahlen gibt, die größer als der größte Index in der Menge der erlaubten Symbole ist, wird die Menge der erlaubten Symbole so lange verdoppelt, bis diese größer/gleich 255 ist.
Danach werden die Zufallszahlen über eine API von einem Quantencomputer gezogen.
Falls die Passwortlänge größer als 255 ist, wird die Menge der erlaubten Symbole mit dem ganzzahligen Anteil des Quotienten aus der Passwortlänge und 255 multipliziert.
Am Ende setzt sich das Passwort aus den Zeichen zusammen, welche in der Menge der Zufallszahlen ist.
</details>
</details>