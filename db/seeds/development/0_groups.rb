# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

require Rails.root.join('db/seeds/support/group_seeder')

seeder = GroupSeeder.new

root = Group.roots.first
srand(42)

if root.address.blank?
  root.update!(seeder.group_attributes)
  root.default_children.each do |child_class|
    child_class.first.update!(seeder.group_attributes)
  end
end

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
end

Group.rebuild!
