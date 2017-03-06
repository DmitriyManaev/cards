require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://www.learnathome.ru/blog/100-beautiful-words'))

doc.search('//table/tbody/tr').each do |row|
  original = row.search('td[2]')[0].content.downcase
  translated = row.search('td[4]')[0].content.downcase
  Card.create(original_text: original, translated_text: translated, user_id: 1, block_id: 1)
end