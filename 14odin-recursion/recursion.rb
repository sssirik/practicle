# frozen_string_literal: true

require_relative 'merge_sort'

def fibs(length)
  return [0] if length == 1

  result = [0, 1]
  (length - 2).times do
    result << (result[-1] + result[-2])
  end
  result
end

def fibs_rec(length)
  return [0] if length == 1
  return [0, 1] if length == 2

  result = fibs_rec(length - 1)
  result << (result[-1] + result[-2])
end

loop do
  puts '1. Fibonacci Sequence'
  puts '2. Fibonacci Sequence (Recursive)'
  puts '3. Exit'
  print 'Choose: '
  choose = gets.chomp.to_i
  puts

  case choose
  when 1
    print '<Fibonacci Sequence> n = '
    puts merge_sort(fibs(gets.chomp.to_i)).map(&:to_s).join(', ')
  when 2
    print '<Fibonacci Sequence (Recursive)> n = '
    puts merge_sort(fibs_rec(gets.chomp.to_i)).map(&:to_s).join(', ')
  when 3
    break
  else puts 'Invalid input, try again.'
  end
  puts
end