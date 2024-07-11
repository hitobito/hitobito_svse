# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

namespace :app do
  namespace :license do
    task :config do # rubocop:disable Rails/RakeEnvironment
      @licenser = Licenser.new("hitobito_svse",
        "Schweizerischer Sportverband öffentlicher Verkehr",
        "https://github.com/hitobito/hitobito_svse")
    end
  end
end
