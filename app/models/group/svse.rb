# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Svse < ::Group

  self.layer = true

  children Group::RessortMitarbeitende,
           Group::TechnischeKomission,
           Group::Ehrenmitglieder,
           Group::ExterneKontakte,
           Group::Sektion

  ### ROLES

  class Geschaeftsleitung < ::Role
    self.permissions = [:layer_and_below_full, :admin]
  end

  class Kassier < ::Role
    self.permissions = [:finance, :layer_and_below_full, :contact_data]
  end

  class Praesident < ::Role; end
  class Mutationsfuehrer < ::Role; end
  class Sponsor < ::Role; end
  class LoginLernende < ::Role; end
  class Freimitglied < ::Role; end
  class Ehrenmitglied < ::Role; end
  class Junior < ::Role; end

  roles Praesident,
        Geschaeftsleitung,
        Mutationsfuehrer,
        Kassier,
        Sponsor,
        LoginLernende,
        Freimitglied,
        Ehrenmitglied,
        Junior

end
