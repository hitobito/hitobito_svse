# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

require Rails.root.join('db/seeds/support/group_seeder')

seeder = GroupSeeder.new

root = Group.roots.first

Group::RessortMitarbeitende.seed_once(:name, :parent_id,
                                      parent_id: root.id,
                                      name: 'Ressortmitarbeitende')

Group::TechnischeKomission.seed_once(:name, :parent_id,
                                     parent_id: root.id,
                                     name: 'Technische Komission TK')

Group::Ehrenmitglieder.seed_once(:name, :parent_id,
                                 parent_id: root.id,
                                 name: 'Ehrenmitglieder')

Group::Passivmitglieder.seed_once(:name, :parent_id,
                                  parent_id: root.id,
                                  name: 'Passivmitglieder')

Group::Ehemalige.seed_once(:name, :parent_id,
                           parent_id: root.id,
                           name: 'Ehemalige')

Group::ExterneKontakte.seed_once(:name, :parent_id,
                                 parent_id: root.id,
                                 name: 'Externe Kontakte')

sektionen = Group::Sektion
            .seed(:name, :parent_id,
                  { name: 'ESV Olten',
                    short_name: 'ESV Olten',
                    zip_code: '4600',
                    town: 'Olten',
                    country: 'CH',
                    email: 'info@esvolten.ch',
                    parent_id: root.id },
                  { name: 'ESV Luzern',
                    short_name: 'ESV Luzern',
                    zip_code: '6002',
                    town: 'Luzern',
                    country: 'CH',
                    email: 'info@esv-luzern.ch',
                    parent_id: root.id })

sektionen.each do |s|
  seeder.seed_social_accounts(s)

  Group::Vorstand.seed_once(:name, :parent_id,
                            parent_id: s.id,
                            name: 'Vorstand')

  Group::Ehemalige.seed_once(:name, :parent_id,
                            parent_id: s.id,
                            name: 'Ehemalige')

  Group::Passivmitglieder.seed_once(:name, :parent_id,
                            parent_id: s.id,
                            name: 'Passivmitglieder')

  Group::Funktionaere.seed_once(:name, :parent_id,
                                parent_id: s.id,
                                name: 'Funktionaere')

  %w(Bergsteigen Mountainbike Badminton Fussball Golf).each do |sa|
    Group::Sportart.seed_once(:name, :parent_id,
                              parent_id: s.id,
                              name: sa)
  end
end

Group.rebuild!
