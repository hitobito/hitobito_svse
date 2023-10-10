# frozen_string_literal: true

#  Copyright (c) 2022, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

require 'spec_helper'

describe InvoiceAbility do

  subject { ability }

  let(:ability) { Ability.new(role.person.reload) }
  let(:role) { roles(:kassier) }
  let(:invoice) { Invoice.new(group: groups(:esv_luzern)) }

  it 'may create in bottom_layer_one' do
    expect(ability).to be_able_to(:create, invoice)
  end
end
