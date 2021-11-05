# frozen_string_literal: true

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class Group::Anlass < ::Group

  self.layer = true

  class Kassier < ::Role
    self.permissions = [:finance, :group_read]
  end

  class Organisationsmitglied < ::Role
    self.permissions = [:group_full]
  end

  roles Kassier,
        Organisationsmitglied
end
