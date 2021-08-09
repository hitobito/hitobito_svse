# encoding: utf-8

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class AddSvseAttributes < ActiveRecord::Migration[6.0]
  def change
    add_reference :people, :recruited_by, index: false
    add_column :people, :recruited_at, :date
    add_column :people, :title, :string
    add_column :people, :died_at, :date
    add_column :people, :iban, :string
    add_column :people, :occupation, :string
    add_column :people, :state, :string, limit: 10, nullable: false, default: 'active'
  end
end
