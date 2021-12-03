# hitobito_svse

A hitobito wagon defining the organization hierarchy and additional features for SVSE

# Rollen, Berechtigungen

```
* SVSE
  * SVSE
    * Mutationsführer: [:layer_and_below_full]
    * Sponsor: []
    * IT Support: [:layer_and_below_full, :contact_data, :admin, :impersonation]
  * Geschäftsleitung
    * Mitglied: [:layer_and_below_read, :contact_data]
    * Kassier: [:layer_and_below_read, :layer_full, :contact_data]
  * Ressortmitarbeitende
    * Mitglied: []
  * Technische Komission
    * Mitglied: [:layer_and_below_read]
  * Ehrenmitglieder
    * Mitglied: []
  * Passivmitglieder
    * Mitglied: []
  * Externe Kontakte
    * Kontakt: []
  * Ehemalige
    * Mitglied: []
  * Sektion
    * Sektion
      * Mutationsführer: [:layer_and_below_full]
      * Kassier: [:finance, :layer_and_below_full, :contact_data]
      * Mitglied: []
      * Login Lernende: [:group_read]
      * Freimitglied: []
      * Junior: [:group_read]
      * Sponsor: []
    * Vorstand
      * Mitglied: [:layer_and_below_full, :contact_data]
    * Sportart
      * Obfrau/-Mann: [:layer_full]
      * Mitglied: []
    * Funktionäre
      * Mitglied: [:layer_full]
    * Anlass
      * Kassier: [:finance, :group_read]
      * Organisationsmitglied: [:group_full]
    * Passivmitglieder
      * Mitglied: []
    * Externe Kontakte
      * Kontakt: []
    * Ehemalige
      * Mitglied: []
    * Ehrenmitglieder
      * Mitglied: []
```
