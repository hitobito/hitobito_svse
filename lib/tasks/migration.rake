# frozen_string_literal: true

require_relative '../../app/domain/data_extraction'

# rubocop:disable Metrics/BlockLength,Rails/RakeEnvironment
namespace :migration do
  task :clean do
    rm_f 'db/seeds/production/people.csv'
    rm_f 'db/seeds/production/companies.csv'
    rm_f 'db/seeds/production/sport_memberships.csv'
    rm_f 'db/seeds/production/functions.csv'
    rm_f 'db/seeds/production/subscriptions.csv'
  end

  task extract: [
    'db/seeds/production/people.csv',
    'db/seeds/production/companies.csv',
    'db/seeds/production/sport_memberships.csv',
    'db/seeds/production/functions.csv',
    'db/seeds/production/subscriptions.csv'
  ]

  task prepare_seed: [:extract] do
    cp 'db/seeds/production/0_people.rb', 'db/seeds/0_people.rb'
  end
end

directory 'db/seeds/production'

file('db/seeds/production/people.csv').clear
file 'db/seeds/production/people.csv' => 'db/seeds/production' do |task|
  migrator = DataExtraction.new(task.name, 'postgres')
  migrator.query('biz_contact', <<~SQL, <<~CONDITIONS)
    biz_contact.firstname as first_name,
    biz_contact.lastname as last_name,
    biz_contact.email as email,
    CASE salutation_lov.lovlic
      WHEN 'Lov.Cfm.Salutation.Mr' THEN 'm'
      WHEN 'Lov.Cfm.Salutation.Mrs' THEN 'w'
      ELSE NULL
    END AS gender,
    biz_address.addressline1 AS address,
    country_lov.lovlic AS country,
    biz_address.city AS town,
    biz_address.zip AS zip_code,
    recruited_by.firstname AS recruited_by_first_name,
    recruited_by.lastname AS recruited_by_last_name,
    recruited_by_address.addressline1 AS recruited_by_address,
    biz_contact.createdon AS recruited_at,
    biz_contact.title,
    biz_contact.birthdate AS birthday,
    state_lov.lovlic AS state,
    biz_contact.deathdate AS died_at,
    biz_contact.ismember AS is_member,
    biz_bankpost.iban AS iban,
    biz_contact.textfield1 AS occupation,
    biz_contact.mobile AS mobile_phone_number,
    biz_contact.mainphone AS main_phone_number,
    biz_contact.memberentrydate AS joined_at
  SQL
    LEFT JOIN biz_bankpost ON biz_contact.prbankpostid=biz_bankpost.id
    LEFT JOIN biz_address ON biz_contact.praddressid=biz_address.id
    LEFT JOIN biz_company ON biz_contact.companyid=biz_company.id
    LEFT JOIN aes_lov AS state_lov ON biz_contact.contactstatusid=state_lov.id
    LEFT JOIN biz_contact AS recruited_by ON biz_contact.referredbycontactid=recruited_by.id
    LEFT JOIN biz_address AS recruited_by_address ON recruited_by.praddressid=recruited_by_address.id
    LEFT JOIN aes_lov AS canton_lov ON biz_address.cantonid=canton_lov.id
    LEFT JOIN aes_lov AS country_lov ON biz_address.countryid=country_lov.id
    LEFT JOIN aes_lov AS salutation_lov ON biz_contact.salutationid=salutation_lov.id
    WHERE biz_contact.deleted='f'
  CONDITIONS
  migrator.dump
end

file('db/seeds/production/companies.csv').clear
file 'db/seeds/production/companies.csv' => 'db/seeds/production' do |task|
  migrator = DataExtraction.new(task.name, 'postgres')
  migrator.query('biz_company', <<~SQL, <<~CONDITIONS)
    biz_company.name as company_name,
    biz_company.email as email,
    biz_address.addressline1 AS address,
    country_lov.lovlic AS country,
    biz_address.city AS town,
    biz_address.zip AS zip_code
  SQL
    LEFT JOIN biz_address ON biz_company.praddressid=biz_address.id
    LEFT JOIN aes_lov AS canton_lov ON biz_address.cantonid=canton_lov.id
    LEFT JOIN aes_lov AS country_lov ON biz_address.countryid=country_lov.id
    WHERE biz_company.deleted='f'
  CONDITIONS
  migrator.dump
end

file('db/seeds/production/sport_memberships.csv').clear
file 'db/seeds/production/sport_memberships.csv' => 'db/seeds/production' do |task|
  migrator = DataExtraction.new(task.name, 'postgres')
  migrator.query('biz_contact_sport', <<~SQL, <<~CONDITIONS)
    biz_contact.firstname AS first_name,
    biz_contact.lastname AS last_name,
    biz_address.addressline1 AS address,
    sport.lovlic AS sportart,
    aes_org.name AS section_name
  SQL
    LEFT JOIN aes_lov as sport ON biz_contact_sport.sportid=sport.id
    LEFT JOIN biz_contact ON biz_contact_sport.contactid=biz_contact.id
    LEFT JOIN biz_address ON biz_contact.praddressid=biz_address.id
    LEFT JOIN aes_org ON biz_contact_sport.ownersuborgid=aes_org.id
    WHERE biz_contact_sport.deleted='f'
  CONDITIONS
  migrator.dump
end

file('db/seeds/production/functions.csv').clear
file 'db/seeds/production/functions.csv' => 'db/seeds/production' do |task|
  migrator = DataExtraction.new(task.name, 'postgres')
  migrator.query('biz_contact_function', <<~SQL, <<~CONDITIONS)
    biz_contact.firstname AS first_name,
    biz_contact.lastname AS last_name,
    biz_address.addressline1 AS address,
    biz_function.name AS function_name,
    section.name AS section_name
  SQL
    LEFT JOIN biz_contact ON biz_contact_function.contactid=biz_contact.id
    INNER JOIN biz_function ON biz_contact_function.functionid=biz_function.id
    LEFT JOIN aes_org AS section ON biz_contact_function.ownersuborgid=section.id
    LEFT JOIN biz_address ON biz_contact.praddressid=biz_address.id
    WHERE biz_contact.deleted='f'
  CONDITIONS

  migrator.dump
end

file('db/seeds/production/subscriptions.csv').clear
file 'db/seeds/production/subscriptions.csv' => 'db/seeds/production' do |task|
  migrator = DataExtraction.new(task.name, 'postgres')
  migrator.query('biz_contact', <<-SQL.strip_heredoc, <<-CONDITIONS.strip_heredoc)
    biz_contact.firstname as first_name,
    biz_contact.lastname as last_name,
    biz_address.addressline1 AS address,
    biz_contact.noadvertising AS no_advertising,
    newsletter_dachverband.lovlic AS newsletter_dachverband_subscriber,
    bulletin.lovlic AS bulletin_subscriber,
    versand.lovlic AS versand_subscriber,
    newsletter_sektion.lovlic AS newsletter_sektion_subscriber
  SQL
    LEFT JOIN biz_address ON biz_contact.praddressid=biz_address.id
    LEFT JOIN aes_lov AS newsletter_dachverband ON biz_contact.abo1id=newsletter_dachverband.id
    LEFT JOIN aes_lov AS bulletin ON biz_contact.abo2id=bulletin.id
    LEFT JOIN aes_lov AS versand ON biz_contact.abo3id=versand.id
    LEFT JOIN aes_lov AS newsletter_sektion ON biz_contact.abo4id=newsletter_sektion.id
    WHERE biz_contact.deleted='f'
  CONDITIONS

  migrator.dump
end
# rubocop:enable Metrics/BlockLength,Rails/RakeEnvironment
