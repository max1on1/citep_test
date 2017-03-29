require 'rubygems'
require 'sqlite3'
require 'nokogiri'
require 'open-uri'
require 'time'

def null(str)
  if str == ' ... '
    return 'NULL'
  else
    return str.to_i
  end
end

page = Nokogiri::HTML(open("http://bash.im"))

db = SQLite3::Database.open "test.db"

db.execute 'CREATE TABLE IF NOT EXISTS `Quotes` (
          `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
          `number` INTEGER,
          `date` TEXT,
          `time` TEXT,
          `rate` TEXT,
          `text` TEXT);'

page.xpath(".//div[@class='quote']").each do |div|
  if div.xpath(".//a[@class='id']").text.gsub(/[^\d]/, '').to_i != 0
    quote_params = { number: div.xpath(".//a[@class='id']").text.gsub(/[^\d]/, '').to_i,
                     date_and_time:  div.xpath(".//span[@class='date']").text ,
                     rate: div.xpath(".//span[@class='rating']").text,
                     text: div.xpath(".//div[@class='text']").text }

    prp = db.prepare( "INSERT INTO Quotes ( number, 
                                          date,
                                          time, 
                                          rate, 
                                          text ) 
                                          VALUES ( ?,?,?,?,? )")        
    prp.execute(quote_params[:number],
                Date.parse(quote_params[:date_and_time],"%Y%m%d").to_s,
                quote_params[:date_and_time].split(" ").last,
                null(quote_params[:rate]),
                quote_params[:text])
  end


  
end
