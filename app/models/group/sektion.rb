# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Sektion < ::Group

  self.layer = true

  children Group::Sportart,
           Group::Anlass,
           Group::ExterneKontakte

  ### ROLES

  class Mutationsfuehrer < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Kassier < ::Role
    self.permissions = [:finance, :layer_and_below_full]
  end

  class Ehrenmitglied < ::Role
    self.permissions = [:group_read]
  end

  class LoginLernende < ::Role
    self.permissions = [:group_read]
  end

  class Junior < ::Role
    self.permissions = [:group_read]
  end

  class ObmannSportart < ::Role
    self.permissions = [:group_full]
  end

  class Praesident < ::Role
    self.permissions = [:group_full]
  end

  class Freimitglied < ::Role; end
  class Mitglied < ::Role; end
  class ReadOnly < ::Role; end


  roles Praesident,
        ObmannSportart,
        Mutationsfuehrer,
        Kassier,
        Mitglied,
        ReadOnly,
        Ehrenmitglied,
        LoginLernende,
        Freimitglied,
        Junior

end
