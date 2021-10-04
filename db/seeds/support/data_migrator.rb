# encoding: utf-8

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_svse and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

# Support for better readable migration/seed-files
class DataMigrator

  class << self
    def remove_lov_prefix(country_phrase)
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
      person = person_from_row(recruited_person_row)
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

    def role_attrs_from_sport_participation(row, person)
      group = sportart_from_row(row)

      return unless group && person

      {
        person_id: person.id,
        group_id: group.id,
        type: 'Group::Sportart::Mitglied'
      }
    end

    def role_attrs_for_login_apprentice(person)
      return unless person

      {
        person_id: person.id,
        group_id: Group.find_by(name: 'SVSE').id,
        type: "Group::Svse::LoginLernende"
      }
    end

    def role_attrs_for_freimitglied(row, person)
      return [] unless person

      section = section_from_row(row)

      return [] unless section
      
      [
        {
          person_id: person.id,
          group_id: section.id,
          type: "Group::Sektion::Freimitglied"
        }
      ]
    end

    def role_attrs_for_ombudsperson(row, person)
      return [] unless row[:sportart] && person

      group = sportart_from_row(row)

      return [] unless group

      [
        {
          person_id: person.id,
          group_id: group.id,
          type: "Group::Sportart::OmbudsPerson"
        }
      ]
    end

    def role_attrs_from_function(row, person)
      return [] unless person

      supported_functions = {
        JuniorIn: 'Junior',
        Ehrenmitglied: 'Ehrenmitglied',
      }

      role_type = supported_functions[row[:function_name].to_sym]

      section = section_from_row(row)

      return [] unless role_type && section
      
      [
        {
          person_id: person.id,
          group_id: section.id,
          type: "Group::Sektion::#{role_type}"
        },
        {
          person_id: person.id,
          group_id: Group.find_by(name: 'SVSE').id,
          type: "Group::Svse::#{role_type}"
        }
      ].reject { |attrs| Role.exists?(attrs) }
    end

    def subscriptions_attrs(row)
      person = person_from_row(row)

      attrs = []

      if row[:no_advertising] == 'f'
        attrs << {
          subscriber_type: 'Person',
          subscriber_id: person.id,
          mailing_list_id: dachverband_mailing_list(:advertising).id
        }
      end

      [:newsletter_dachverband_subscriber,
       :bulletin_subscriber].each do |key|
         if remove_lov_prefix(row[key]) == 'Yes'
           attrs << {
             subscriber_type: 'Person',
             subscriber_id: person.id,
             mailing_list_id: dachverband_mailing_list(key).id
           }
         end
      end

      [:versand_subscriber,
       :newsletter_section_subscriber].each do |key|
         if remove_lov_prefix(row[key]) == 'Yes'
           attrs += person.groups.map do |group|
             {
               subscriber_type: 'Person',
               subscriber_id: person.id,
               mailing_list_id: versand_mailing_list(key, group).id
             }
           end
         end
       end

      attrs.flatten.reject { |subscription_attrs| Subscription.exists?(subscription_attrs) }
    end

    def person_from_row(row)
      Person.find_by(first_name: row[:first_name],
                     last_name: row[:last_name],
                     address: row[:address])
    end

    def retrieve_boolean(value)
      value == "t"
    end

    private

    def dachverband_mailing_list(key)
      name = {
        advertising: 'Werbung SVSE',
        newsletter_dachverband_subscriber: 'Newsletter',
        bulletin_subscriber: 'Bulletin'
      }[key]

      MailingList.find_or_create_by(name: name,
                                    group_id: Group.find_by(name: 'SVSE').id,
                                    subscribable: true)
    end

    def section_mailing_list(key, group)
      name = {
        versand_subscriber: 'Versand',
        newsletter_section_subscriber: 'Newsletter',
      }[key]

      MailingList.find_or_create_by(name: name,
                                    group_id: group.layer_group.id,
                                    subscribable: true)
    end

    def section_from_row(row)
      section_name = row[:section_name] == 'COMMON' ? row[:common_section_name] : row[:section_name]

      Group.find_or_create_by(name: section_name.delete_suffix('(Mandant)').strip,
                              type: 'Group::Sektion',
                              parent_id: Group.find_by(name: 'SVSE').id)
    end

    def sportart_from_row(row)
      section = section_from_row(row)

      return unless section

      Group.find_or_create_by(name: remove_lov_prefix(row[:sportart]),
                              parent_id: section.id,
                              type: 'Group::Sportart')
    end

    def is_number?(value)
      true if Float(value) rescue false
    end
  end
end
