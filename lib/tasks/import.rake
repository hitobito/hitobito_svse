# frozen_string_literal: true

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

require Wagons.find('svse').root.join('db/seeds/support/data_migrator.rb')

# rubocop:disable Metrics/BlockLength
namespace :import do
  desc 'Import people'
  task people: [:environment] do
    person_csv = Wagons.find('svse').root.join('db/seeds/production/people.csv')
    raise unless person_csv.exist?

    raw_recruited_people = []

    # Get tag id for non_member tagging
    non_member_tag = ActsAsTaggableOn::Tag.find_or_create_by(name: 'Nicht Mitglied im Dachverband')

    CSV.parse(person_csv.read, headers: true, header_converters: :symbol).each do |person_row|
      person_hash = person_row.to_h.except(:recruited_by_first_name,
                                           :recruited_by_last_name,
                                           :recruited_by_address)

      person_hash[:email] = DataMigrator.person_email(person_hash)
      person_hash[:country] = DataMigrator.remove_lov_prefix(person_hash[:country])
      person_hash[:occupation] = DataMigrator.check_occupation(person_hash[:occupation])
      person_hash[:created_at] = person_hash.delete(:joined_at)
      person_hash[:created_at] ||= Time.zone.now
      person_hash[:updated_at] = person_hash[:created_at]

      if person_hash[:died_at].present?
        person_hash[:state] = 'deceased'
      else
        person_hash[:state] = case DataMigrator.remove_lov_prefix(person_hash[:state])
                              when 'Active' then 'active'
                              when 'Passive', 'General' then 'passive'
                              when 'Inactive' then 'resigned'
                              when 'Departed' then 'deceased'
                              end
      end
      is_member = DataMigrator.retrieve_boolean(person_hash.delete(:is_member))

      mobile_phone_number = person_hash.delete(:mobile_phone_number)
      main_phone_number = person_hash.delete(:main_phone_number)

      common_section_name = person_hash.delete(:common_section_name)

      person_hash[:id] = DataMigrator.person_from_row(person_hash)&.id

      Person.upsert(person_hash.to_h)

      person = DataMigrator.person_from_row(person_hash)

      unless is_member
        ActsAsTaggableOn::Tagging.upsert({
          tag_id: non_member_tag.id,
          taggable_id: person.id,
          taggable_type: 'Person',
          context: 'tags',
          tagger_id: 1,
          tagger_type: 'Person'
        })
      end

      phone_attrs = DataMigrator.phone_number_attributes(mobile_phone_number,
                                                         main_phone_number,
                                                         person.id)

      phone_numbers_exist = PhoneNumber.exists?(contactable_type: 'Person',
                                                contactable_id: person.id)
      common_membership_attrs = DataMigrator.role_attrs_for_common_membership(person,
                                                                              common_section_name)
      common_membership_attrs.merge!({
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      })

      Role.upsert(common_membership_attrs) if !Role.exists?(common_membership_attrs) && is_member

      PhoneNumber.upsert_all(phone_attrs) unless phone_attrs.empty? || phone_numbers_exist

      raw_recruited_people << person_row if person_row[:recruited_by_first_name].present?
    end

    raw_recruited_people.each do |recruited_person_row|
      DataMigrator.update_recruited_attributes(recruited_person_row)
    end

    puts 'Personen erfolgreich importiert!'
  end

  desc 'Import companies'
  task companies: [:environment] do
    companies_csv = Wagons.find('svse').root.join('db/seeds/production/companies.csv')
    raise unless companies_csv.exist?

    CSV.parse(companies_csv.read, headers: true, header_converters: :symbol).each do |company_row|
      company_hash = company_row.to_h
      company_hash[:email] = DataMigrator.person_email(company_hash)

      company_hash[:country] = DataMigrator.remove_lov_prefix(company_hash[:country])

      company_hash[:created_at] = Time.zone.now
      company_hash[:updated_at] = company_hash[:created_at]

      Person.upsert(company_hash.to_h.merge(company: true))

      role_attrs = {
        type: 'Group::Svse::Sponsor',
        group_id: Group.find_by(name: 'SVSE').id,
        person_id: DataMigrator.person_from_row(company_row).id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }

      next if Role.exists?(role_attrs)

      Role.upsert(role_attrs)
    end

    puts 'Unternehmen erfolgreich importiert!'
  end

  desc 'Import sports memberships as roles'
  task sport_memberships: [:environment] do
    sport_memberships_csv = Wagons.find('svse')
                                  .root
                                  .join('db/seeds/production/sport_memberships.csv')
    raise unless sport_memberships_csv.exist?

    CSV.parse(sport_memberships_csv.read,
              headers: true,
              header_converters: :symbol).each do |sport_membership_row|
      sport_membership_hash = sport_membership_row.to_h

      person = DataMigrator.person_from_row(sport_membership_row)

      next if person&.resigned?

      if sport_membership_hash[:section_name] == 'login Lernende (Mandant)'
        attrs = DataMigrator.role_attrs_for_login_apprentice(person)
      else
        attrs = DataMigrator.role_attrs_from_sport_participation(sport_membership_hash, person)
      end

      next if attrs.nil? || Role.exists?(attrs)

      attrs[:created_at] = Time.zone.now
      attrs[:updated_at] = attrs[:created_at]

      Role.upsert(attrs)
    end

    puts 'Sport Teilnahmen als Rollen erfolgreich importiert!'
  end

  desc 'Import functions as roles'
  task functions: [:environment] do
    functions_csv = Wagons.find('svse').root.join('db/seeds/production/functions.csv')
    raise unless functions_csv.exist?

    CSV.parse(functions_csv.read, headers: true, header_converters: :symbol).each do |function_row|
      function_hash = function_row.to_h

      person = DataMigrator.person_from_row(function_row)

      next if person&.resigned?

      attrs = DataMigrator.role_attrs_from_function(function_hash, person)

      next if attrs.empty?

      timestamps = { created_at: Time.zone.now, updated_at: Time.zone.now }

      attrs.map! { |a| a.merge(timestamps) }

      Role.upsert_all(attrs)
    end

    puts 'Funktionen als Rollen erfolgreich importiert!'
  end

  desc 'Import subscriptions'
  task subscriptions: [:environment] do
    subscriptions_csv = Wagons.find('svse').root.join('db/seeds/production/subscriptions.csv')
    raise unless subscriptions_csv.exist?

    CSV.parse(subscriptions_csv.read,
              headers: true,
              header_converters: :symbol).each do |subscription_row|
      subscription_hash = subscription_row.to_h
      attrs = DataMigrator.subscriptions_attrs(subscription_hash)

      next if attrs.empty?

      attrs[:created_at] = Time.zone.now
      attrs[:updated_at] = attrs[:created_at]

      Subscription.upsert_all(attrs)
    end

    puts 'Abonnements erfolgreich importiert!'
  end
end
# rubocop:enable Metrics/BlockLength
