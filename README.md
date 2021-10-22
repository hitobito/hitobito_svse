# hitobito_svse

A hitobito wagon defining the organization hierarchy and additional features for SVSE

# Rollen, Berechtigungen

* SVSE
  * SVSE
    * Präsident: [:group_full]
    * Geschäftsleitung: [:layer_and_below_full, :admin]
    * Mutationsführer: [:layer_and_below_full]
    * IT Support: [:layer_and_below_full, :admin, :contact_data, :impersonation]
    * Kassier: [:finance, :layer_and_below_full, :contact_data]
    * Sponsor: []
    * Login Lernende: [:group_read]
    * Freimitglied: [:group_read]
    * Ehrenmitglied: []
    * Junior: [:group_read]
  * Ressortmitarbeitende
    * Mitglied: []
  * Technische Komission
    * Mitglied: [:layer_and_below_full]
  * Ehrenmitglieder
    * Mitglied: []
* Sektion
  * Sektion
    * Präsident: [:group_full]
    * Obmann Sportart: [:group_full]
    * Mutationsführer: [:layer_and_below_full]
    * Kassier: [:finance, :layer_and_below_full]
    * Mitglied: []
    * Read Only: []
    * Ehrenmitglied: [:group_read]
    * Login Lernende: [:group_read]
    * Freimitglied: [:group_read]
    * Junior: [:group_read]
  * Sportart
    * Ombudsfrau/-mann: [:group_full]
    * Mitglied: []
* Global
  * Externe Kontakte
    * Kontakt: []
