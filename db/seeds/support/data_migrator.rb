# encoding: utf-8

#  Copyright (c) 2018 - 2019, Schweizer Blasmusikverband. This file is part of
#  hitobito_sbv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sbv.

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

    private

    def is_number?(value)
      true if Float(value) rescue false
    end
  end
end
