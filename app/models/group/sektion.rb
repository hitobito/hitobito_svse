# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Sektion < ::Group

  self.layer = true
  self.event_types = [Event, Event::Course]

  children Group::Vorstand,
           Group::Sportart,
           Group::Anlass,
           Group::Ehemalige,
           Group::Freimitglieder,
           Group::Passivmitglieder,
           Group::Ehrenmitglieder,
           Group::ExterneKontakte,
           Group::Funktionaere

  ### ROLES

  class Mutationsfuehrer < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Kassier < ::Role
    self.permissions = [:finance, :layer_and_below_full, :contact_data]
  end

  class LoginLernende < ::Role
    self.permissions = [:group_read]
  end

  class Junior < ::Role
    self.permissions = [:group_read]
  end

  class Mitglied < ::Role; end
  class Sponsor < ::Role; end


  roles Mutationsfuehrer,
        Kassier,
        Mitglied,
        LoginLernende,
        Junior,
        Sponsor

end
