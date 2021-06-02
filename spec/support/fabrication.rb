# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


Fabrication.configure do |config|
  config.fabricator_path = ['spec/fabricators',
                            '../hitobito_svse/spec/fabricators']
  config.path_prefix = Rails.root
end
