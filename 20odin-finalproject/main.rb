
require_relative 'lib/chess_game'

def play_chess
  game = ChessGame.new
  puts "Добро пожаловать в шахматы!"
  puts "Используйте шахматную нотацию (например, e2-e4)"
  puts "Для сохранения игры введите 'save'"
  puts "Для выхода введите 'quit'"
  puts

  game.load_game if File.exist?('chess_save.yaml')

  until game.game_over?
    game.display_board
    puts
    puts "Ход #{game.current_player == :white ? 'белых' : 'черных'}"
    
    begin
      print "Введите ход: "
      input = gets.chomp.downcase
      
      case input
      when 'quit'
        puts "Игра завершена."
        return
      when 'save'
        game.save_game
        puts "Игра сохранена!"
        next
      when 'load'
        game.load_game
        puts "Игра загружена!"
        next
      end

      if game.make_move(input)
        if game.checkmate?
          game.display_board
          puts "Шах и мат! Победили #{game.current_player == :white ? 'белые' : 'черные'}!"
          return
        elsif game.stalemate?
          game.display_board
          puts "Пат! Ничья!"
          return
        elsif game.check?
          puts "Шах!"
        end
        
        game.switch_player
      else
        puts "Неверный ход! Попробуйте снова."
      end
      
    rescue Interrupt
      puts "\nИгра прервана."
      return
    rescue => e
      puts "Ошибка: #{e.message}"
    end
  end
end

# Запуск игры
if __FILE__ == $0
  play_chess
end