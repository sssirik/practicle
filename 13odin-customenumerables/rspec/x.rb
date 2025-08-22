# frozen_string_literal: true

# Добавьте эти методы в класс Array
class Array
  include Enumerable
end

# Тесты
arr = [1, 2, 3, 4, 5]

puts "Original: #{arr}"
puts 'Each * 2:'
arr.my_each { |x| puts x * 2 }

puts "Select even: #{arr.my_select(&:even?)}"
puts "Map * 2: #{arr.my_map { |x| x * 2 }}"
puts "All even?: #{arr.my_all?(&:even?)}"
puts "Any even?: #{arr.my_any?(&:even?)}"
puts "Sum: #{arr.my_inject(0) { |sum, n| sum + n }}"
