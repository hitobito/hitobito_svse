#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

module Svse::FormatHelper

  def format_person_created_at(person)
    f(person.created_at.to_date)
  end

  def format_person_state(person)
    person.state_label
  end
end
