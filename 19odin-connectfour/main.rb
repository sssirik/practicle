# frozen_string_literal: true

require_relative 'lib/connect_four'

def play_game
  game = ConnectFour.new
  puts "Добро пожаловать в Connect Four!"
  puts "Игрок 1: X"
  puts "Игрок 2: O"
  puts

  until game.board_full? || game.winner?(1) || game.winner?(2)
    game.print_board
    puts
    puts "Ход игрока #{game.current_player} (#{game.current_player == 1 ? 'X' : 'O'})"
    
    begin
      print "Выберите колонку (0-6): "
      column = gets.chomp.to_i
      
      unless game.drop_piece(column)
        puts "Неверный ход! Попробуйте другую колонку."
        next
      end
      
      if game.winner?(game.current_player)
        game.print_board
        puts
        puts "Игрок #{game.current_player} (#{game.current_player == 1 ? 'X' : 'O'}) победил!"
        return
      end
      
      game.switch_player
      
    rescue Interrupt
      puts "\nИгра прервана."
      return
    end
  end
  
  game.print_board
  puts
  puts "Ничья! Доска заполнена."
end

# Запуск игры
if __FILE__ == $0
  play_game
end