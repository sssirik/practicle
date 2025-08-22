# frozen_string_literal: true

class Board
  def initialize
    @cells = Array.new(9, ' ')
  end

  def display
    puts "\n  1 | 2 | 3"
    puts ' -----------'
    puts '  4 | 5 | 6'
    puts ' -----------'
    puts '  7 | 8 | 9'
    puts "\nТекущее поле:"
    puts "  #{@cells[0]} | #{@cells[1]} | #{@cells[2]}"
    puts ' -----------'
    puts "  #{@cells[3]} | #{@cells[4]} | #{@cells[5]}"
    puts ' -----------'
    puts "  #{@cells[6]} | #{@cells[7]} | #{@cells[8]}"
  end

  def update(position, symbol)
    if valid_move?(position)
      @cells[position - 1] = symbol
      true
    else
      false
    end
  end

  def valid_move?(position)
    position.between?(1, 9) && @cells[position - 1] == ' '
  end

  def full?
    @cells.none?(' ')
  end

  def win?(symbol)
    winning_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], # горизонтальные
      [0, 3, 6], [1, 4, 7], [2, 5, 8], # вертикальные
      [0, 4, 8], [2, 4, 6] # диагональные
    ]

    winning_combinations.any? do |combo|
      combo.all? { |index| @cells[index] == symbol }
    end
  end
end

class Player
  attr_reader :symbol, :name

  def initialize(symbol, name)
    @symbol = symbol
    @name = name
  end

  def make_move(board)
    loop do
      print "#{@name}, выберите клетку (1-9): "
      position = gets.chomp.to_i

      return true if board.update(position, @symbol)

      puts 'Неверный ход! Выберите свободную клетку от 1 до 9.'
    end
  end
end

class TicTacToe
  def initialize
    puts 'Добро пожаловать в Крестики-нолики!'
    puts 'Игрок 1, введите ваше имя: '
    player1_name = gets.chomp
    puts 'Игрок 2, введите ваше имя: '
    player2_name = gets.chomp

    @player1 = Player.new('X', player1_name)
    @player2 = Player.new('O', player2_name)
    @board = Board.new
    @current_player = @player1
  end

  def play
    @board.display

    loop do
      puts "\nХод #{@current_player.name} (#{@current_player.symbol})"
      @current_player.make_move(@board)
      @board.display

      if @board.win?(@current_player.symbol)
        puts "\n🎉 Поздравляем! #{@current_player.name} победил(а)!"
        break
      elsif @board.full?
        puts "\n🤝 Ничья! Игра окончена."
        break
      end

      switch_player
    end

    play_again?
  end

  private

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play_again?
    print "\nХотите сыграть еще раз? (y/n): "
    answer = gets.chomp.downcase
    if answer == 'y'
      TicTacToe.new.play
    else
      puts 'Спасибо за игру!'
    end
  end
end

# Запуск игры
if __FILE__ == $PROGRAM_NAME
  game = TicTacToe.new
  game.play
end
