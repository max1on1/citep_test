require 'rubygems'
require 'sqlite3'
require 'nokogiri'
require 'open-uri'

db = SQLite3::Database.open "test.db"

a = db.execute ( "SELECT `date`,
                         `time`,
                         `text`,
                         `rate`,
                         `number` 
                  FROM Quotes GROUP BY date")
a.each do |quote|
  if quote.include? 'NULL'
    puts 'Рейтинга нет'
  else
    puts '========'
    puts quote
    puts '========'
  end
end