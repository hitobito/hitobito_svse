# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


# TODO: rename class to specific name and change all references
class Group::Root < ::Group

  self.layer = true

  # TODO: define actual child group types
  children Group::Root

  ### ROLES

  # TODO: define actual role types
  class Leader < ::Role
    self.permissions = [:layer_and_below_full, :admin]
  end

  class Member < ::Role
    self.permissions = [:group_read]
  end

  roles Leader, Member

end
