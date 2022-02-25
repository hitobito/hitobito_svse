# frozen_string_literal: true

#  Copyright (c) 2022, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

module Svse::InvoiceAbility
  extend ActiveSupport::Concern

  included do
    on(Invoice) do
      permission(:finance).may(:create).in_layer_or_below_if_active
    end

    def in_layer_or_below_if_active
      in_layer_or_below && !subject.group&.archived?
    end

    def in_layer_or_below(group = subject.group)
      user.finance_groups.flat_map(&:self_and_descendants).uniq.include?(group)
    end
  end
end
