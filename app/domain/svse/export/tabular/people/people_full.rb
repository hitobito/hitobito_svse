# encoding: utf-8

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

module Svse::Export::Tabular::People
  module PeopleFull

    def person_attributes
      super + [:created_at]
    end

  end
end
