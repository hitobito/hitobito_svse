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

    CSV.parse(person_csv.read, headers: true, header_converters: :symbol).each do |person_row|
      create_new_person(person_row.to_h.except(:recruited_by_first_name,
                                               :recruited_by_last_name,
                                               :recruited_by_address))
      raw_recruited_people << person_row if person_row[:recruited_by_first_name].present?
    end

    raw_recruited_people.each do |recruited_person_row|
      update_recruited_attributes(recruited_person_row)
    end

    puts 'Personen erfolgreich importiert!'
  end

  desc 'Import companies'
  task companies: [:environment] do
    companies_csv = Wagons.find('svse').root.join('db/seeds/production/companies.csv')
    raise unless companies_csv.exist?

    CSV.parse(companies_csv.read, headers: true, header_converters: :symbol).each do |company_row|
      create_new_company(company_row.to_h)
    end

    puts 'Unternehmen erfolgreich importiert!'
  end

  private

  def create_new_company(company_hash)
    company_hash[:email] = person_email(company_hash)
      
    company_hash[:country] = DataMigrator.refactor_country(company_hash[:country])

    Person.upsert(company_hash.to_h.merge({ company: true }))
  end

  def create_new_person(person_hash)
    person_hash[:email] = person_email(person_hash)
    person_hash[:country] = DataMigrator.refactor_country(person_hash[:country]),
    person_hash[:occupation] = DataMigrator.check_occupation(person_hash[:occupation])
    person_hash[:created_at] = person_hash.delete(:joined_at)

    mobile_phone_number = person_hash.delete(:mobile_phone_number)
    main_phone_number = person_hash.delete(:main_phone_number)

    Person.upsert(person_hash.to_h)

    person_id = Person.find_by(first_name: person_hash[:first_name],
                               last_name: person_hash[:last_name],
                               address: person_hash[:address]).id

    phone_attrs = phone_number_attributes(mobile_phone_number, main_phone_number, person_id)

    PhoneNumber.upsert_all(phone_attrs) unless phone_attrs.empty?
  end

  def phone_number_attributes(mobile_number, main_number, person_id)
    [
      {
        number: mobile_number,
        label: :Mobil,
        contactable_id: person_id,
        contactable_type: 'Person'
      },
      {
        number: main_number,
        label: "Festnetz",
        contactable_id: person_id,
        contactable_type: 'Person'
      }
    ].select do |phone_number|
      phone_number[:number].present?
    end
  end

  def update_recruited_attributes(recruited_person_row)
    person = Person.find_by(first_name: recruited_person_row[:first_name],
                   last_name: recruited_person_row[:last_name],
                   address: recruited_person_row[:address])
    recruiter = Person.find_by(first_name: recruited_person_row[:recruited_by_first_name],
                               last_name: recruited_person_row[:recruited_by_last_name],
                               address: recruited_person_row[:recruited_by_address])

    return unless person.present? && recruiter.present?

    person.recruited_by = recruiter
    person.recruited_at = person.created_at
    person.save(validate: false)
  end

  def person_email(row)
    return nil if row[:email].present? && Person.exists?(email: row[:mail])

    row[:email]
  end
end
