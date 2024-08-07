# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Svse < ::Group
  self.layer = true
  self.event_types = [Event, Event::Course]

  children Group::Geschaeftsleitung,
    Group::RessortMitarbeitende,
    Group::TechnischeKomission,
    Group::Ehrenmitglieder,
    Group::Ehemalige,
    Group::ExterneKontakte,
    Group::Passivmitglieder,
    Group::Sektion

  class Mutationsfuehrer < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class ItSupport < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :admin, :impersonation]
  end

  class Sponsor < ::Role; end

  roles Mutationsfuehrer,
    ItSupport,
    Sponsor
end
