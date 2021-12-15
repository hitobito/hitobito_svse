# frozen_string_literal: true

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Anlass < ::Group

  self.layer = true
  self.event_types = [Event, Event::Course]

  class Kassier < ::Role
    self.permissions = [:finance, :group_read]
  end

  class Organisationsmitglied < ::Role
    self.permissions = [:group_full]
  end

  class Teilnehmer < ::Role; end

  roles Kassier,
        Organisationsmitglied,
        Teilnehmer
end
