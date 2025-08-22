# frozen_string_literal: true

def stock_picker(prices)
  return [] if prices.empty? || prices.size < 2

  min_price = prices[0]
  min_day = 0
  best_profit = 0
  best_days = []

  prices.each_with_index do |current_price, day|
    if current_price < min_price
      min_price = current_price
      min_day = day
    end

    profit = current_price - min_price
    if profit > best_profit
      best_profit = profit
      best_days = [min_day, day]
    end
  end

  best_days
end

test_cases = [
  [17, 3, 6, 9, 15, 8, 6, 1, 10],
  [10, 20, 5, 15, 30, 2],
  [30, 20, 10, 5],
  [5, 10, 15, 20],
  [20, 15, 10, 5],
  [10],
  []
]

puts 'Тестирование метода stock_picker:'
puts '=' * 50

test_cases.each do |prices|
  result = stock_picker(prices)
  if result.empty?
    puts "#{prices} -> [] (нет прибыли)"
  else
    profit = prices[result[1]] - prices[result[0]]
    puts "#{prices} -> #{result} (прибыль: $#{profit})"
  end
end

loop do
  puts "\n#{'=' * 40}"
  print 'Введите цены акций через запятую: '
  input = gets.chomp

  break if input.empty?

  prices = input.split(',').map(&:strip).map(&:to_i)

  if prices.size < 2
    puts 'Нужно как минимум 2 цены!'
    next
  end

  result = stock_picker(prices)

  if result.empty?
    puts 'Невозможно получить прибыль с этими ценами'
  else
    buy_day, sell_day = result
    buy_price = prices[buy_day]
    sell_price = prices[sell_day]
    profit = sell_price - buy_price

    puts "Лучшие дни: #{result}"
    puts "Купить на день #{buy_day} по $#{buy_price}"
    puts "Продать на день #{sell_day} по $#{sell_price}"
    puts "Прибыль: $#{profit}"
  end
end
