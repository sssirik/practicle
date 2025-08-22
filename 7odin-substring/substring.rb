# frozen_string_literal: true

def substrings_optimized(word, dictionary)
  result = Hash.new(0)
  clean_word = word.downcase.gsub(/[^\w\s]/, ' ')

  dictionary.each do |substring|
    substring_down = substring.downcase
    count = clean_word.scan(/\b#{substring_down}\b/).length
    result[substring] += count if count.positive?
  end

  result.sort.to_h
end

loop do
  print 'Enter text: '
  word = gets.chomp

  print 'Enter dictionary (a, b, c): '
  dictionary = gets.chomp.split(', ')

  result = substrings_optimized(word, dictionary)

  if result.empty?
    puts 'Совпадений не найдено'
  else
    puts result
  end
end
