# frozen_string_literal: true

#  Copyright (c) 2012-2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.


module HitobitoSvse
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement '>= 0'

    # Add a load path for this specific wagon
    config.autoload_paths += %W[
      #{config.root}/app/abilities
      #{config.root}/app/domain
      #{config.root}/app/jobs
    ]

    config.to_prepare do
      ### models
      Group.include Svse::Group
      Person.include Svse::Person
      Event::Course.used_attributes -= [:kind_id]

      ### controllers
      PeopleController.permitted_attrs += [:title, :iban, :occupation, :recruited_by_id,
                                           :recruited_at, :died_at, :state]

      ### domain classes
      TableDisplay.register_column(Person, TableDisplays::PublicColumn, [:created_at])

      Export::Tabular::People::PeopleFull.prepend Svse::Export::Tabular::People::PeopleFull
      Export::Tabular::People::PersonRow.include Svse::Export::Tabular::People::PersonRow

      PublicEventsController.render_application_attrs = false
    end

    initializer 'svse.add_settings' do |_app|
      Settings.add_source!(File.join(paths['config'].existent, 'settings.yml'))
      Settings.reload!
    end

    initializer 'svse.add_inflections' do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        # inflect.irregular 'census', 'censuses'
      end
    end

    private

    def seed_fixtures
      fixtures = root.join('db', 'seeds')
      ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end

  end
end
