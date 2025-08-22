# frozen_string_literal: true

def bubble_sort(array)
  return array if array.empty? || array.size == 1

  arr = array.dup
  n = arr.size
  swapped = true

  while swapped
    swapped = false
    (n - 1).times do |i|
      if arr[i] > arr[i + 1]
        arr[i], arr[i + 1] = arr[i + 1], arr[i]
        swapped = true
      end
    end
    n -= 1
  end

  arr
end

loop do
  puts "\n#{'=' * 50}"
  puts 'СОРТИРОВКА ПУЗЫРЬКОМ'
  puts '=' * 50

  print 'Введите числа через запятую (например: 4,3,78,2,0,2): '
  input = gets.chomp

  if input.downcase == 'exit'
    puts 'Выход из программы...'
    break
  end

  if input.empty?
    puts 'Пожалуйста, введите числа!'
    next
  end

  numbers = input.split(',').map { |item| item.strip.to_i }

  puts "Исходный массив: #{numbers.inspect}"

  sorted_numbers = bubble_sort(numbers)

  puts "Отсортированный массив: #{sorted_numbers.inspect}"
  puts
end
