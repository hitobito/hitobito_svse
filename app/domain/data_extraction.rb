# frozen_string_literal: true

#  Copyright (c) 2021, Schweizerischer Sportverband öffentlicher Verkehr. This file is part of
#  hitobito_sbv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_svse.

class DataExtraction
  include FileUtils

  attr_reader :filename

  def initialize(filename, database)
    @filename = filename
    @database = database
  end

  def query(table = nil, field_sql = '*', condition_sql = '')
    raise ArgumentError, 'Table needs to be passed' if @query.nil? && table.nil?

    @query = <<-SQL.strip_heredoc.split("\n").map(&:strip).join(' ').gsub(/\s+/, ' ')
      COPY(SELECT #{field_sql}
      FROM #{table}
      #{condition_sql})
      to stdout with CSV HEADER
    SQL
  end

  def show_query
    puts @query.gsub(/INTO OUTFILE.*FROM/, 'FROM') # rubocop:disable Rails/Output
  end

  def dump
    write_file(fetch(@database))
  end

  private

  def fetch(database = @database)
    unless @query
      raise "No Query set, please use #{self.class.name}#query(table, fields, joins) to set one"
    end
    
    `psql -h #{ENV['PGHOSTNAME']} -U #{ENV['PGUSERNAME']} -c \"#{@query}\" #{database}`
  end

  def write_file(data)
    File.write(@filename, data)
  end
end
