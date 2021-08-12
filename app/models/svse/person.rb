# frozen_string_literal: true

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


module Svse::Person
  extend ActiveSupport::Concern

  included do
    include I18nEnums

    Person::PUBLIC_ATTRS << :title << :created_at << :died_at << :iban << :occupation <<
                            :recruited_at << :state

    Person::INTERNAL_ATTRS << :recruited_by

    Person::STATES = %w(active passive resigned deceased).freeze

    before_save :set_deceased_state

    belongs_to :recruited_by, class_name: 'Person'

    validates :recruited_at, :died_at,
              timeliness: { type: :date, allow_blank: true, before: Date.new(9999, 12, 31) }

    i18n_enum :state, Person::STATES, scopes: true, queries: true

    def set_deceased_state
      self.state = 'deceased' if self.died_at.present?
    end
  end

end
