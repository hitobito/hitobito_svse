# encoding: utf-8

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

# Support for better readable migration/seed-files
class DataMigrator

  class << self
    def refactor_country(country_phrase)
      country_phrase.to_s.split('.').last
    end

    def check_occupation(occupation)
      return nil if is_number?(occupation.to_s.gsub(/\s+/, ""))

      occupation
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

    private

    def is_number?(value)
      true if Float(value) rescue false
    end
  end
end
