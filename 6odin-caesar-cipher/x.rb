# frozen_string_literal: true

def caesar_cipher(string, shift, result = '')
    alphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze
    shift = shift.to_i % 26
  
    string.chars.each do |symbol|
      if alphabet.include?(symbol.downcase)
        array_index = alphabet.find_index(symbol.downcase)
        new_index = (array_index + shift) % 26
        result += symbol == symbol.upcase ? alphabet[new_index].upcase : alphabet[new_index]
      else
        result += symbol
      end
    end
  
    result
  end
  
  # Только для интерактивного запуска
  if __FILE__ == $PROGRAM_NAME
    loop do
      print 'Enter string: '
      string = gets.chomp
  
      print 'Enter shift: '
      shift = gets.chomp
  
      puts "Encrypted: #{caesar_cipher(string, shift)}"
      puts "Decrypted: #{caesar_cipher(caesar_cipher(string, shift), -shift.to_i)}"
      puts "-" * 30
    end
  end