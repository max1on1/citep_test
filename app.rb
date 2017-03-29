require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://bash.im"))
puts page

page.xpath("//div[@class='quote']").each do |div|
  div
end

