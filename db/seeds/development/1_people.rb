# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

class SvsePersonSeeder < PersonSeeder

  def amount(role_type)
    case role_type.name.demodulize
    when 'Member' then 5
    else 1
    end
  end

end

puzzlers = ['Andreas Maierhofer',
            'Andre Kunz',
            'Nils Rauch',
            'Carlo Beltrame',
            'Tobias Hinderling',
            'Olivier Brian',
            'Pascal Simon']
            

devs = {'Customer Name' => 'customer@email.com'}
puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase}@puzzle.ch"
end

seeder = SvsePersonSeeder.new

seeder.seed_all_roles

root = Group.root
devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::Svse::Geschaeftsleitung)
end
