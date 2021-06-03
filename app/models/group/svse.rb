# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


class Group::Svse < ::Group

  self.layer = true

  children Group::RessortMitarbeitende
           Group::TechnischeKomission
           Group::Ehrenmitglieder
           Group::ExterneKontakte
           Group::Sektion

  self.default_children = [
    Group::RessortMitarbeitende
    Group::TechnischeKomission
    Group::Ehrenmitglieder
    Group::ExterneKontakte
  ]

  ### ROLES

  class Geschaeftsleitung < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Kassier < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  roles Geschaeftsleitung,
        Kassier

end
