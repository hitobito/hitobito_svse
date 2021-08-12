#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.
# == Schema Information
#
# Table name: table_displays
#
#  id        :integer          not null, primary key
#  selected  :text(16777215)
#  type      :string(255)      not null
#  person_id :integer          not null
#
# Indexes
#
#  index_table_displays_on_person_id_and_type  (person_id,type) UNIQUE
#

module Svse::TableDisplay
  private

  def reject_internal_attributes
    selected.reject! do |attr|
      (Person::INTERNAL_ATTRS - [:created_at]).include?(attr.split('.').last.to_sym)
    end
  end
end
