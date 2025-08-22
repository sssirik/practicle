# frozen_string_literal: true

class ConnectFour
    attr_reader :board, :current_player
  
    def initialize
      @board = Array.new(6) { Array.new(7) }
      @current_player = 1
    end
  
    def drop_piece(column)
      return false unless valid_column?(column)
      
      row = find_empty_row(column)
      return false unless row
  
      @board[row][column] = @current_player
      true
    end
  
    def switch_player
      @current_player = @current_player == 1 ? 2 : 1
    end
  
    def winner?(player)
      check_horizontal(player) || check_vertical(player) || check_diagonal(player)
    end
  
    def board_full?
      @board.flatten.none?(&:nil?)
    end
  
    def print_board
      puts "  0 1 2 3 4 5 6"
      puts "  ┌─────────────┐"
      
      @board.each_with_index do |row, i|
        print "#{i} │ "
        row.each do |cell|
          symbol = case cell
                  when 1 then 'X'
                  when 2 then 'O'
                  else ' '
                  end
          print "#{symbol} "
        end
        puts "│"
      end
      
      puts "  └─────────────┘"
      puts "  0 1 2 3 4 5 6"
    end
  
    private
  
    def valid_column?(column)
      column.between?(0, 6)
    end
  
    def find_empty_row(column)
      (5).downto(0) do |row|
        return row if @board[row][column].nil?
      end
      nil
    end
  
    def check_horizontal(player)
      @board.each do |row|
        (0..3).each do |col|
          if row[col] == player && row[col+1] == player && 
             row[col+2] == player && row[col+3] == player
            return true
          end
        end
      end
      false
    end
  
    def check_vertical(player)
      (0..6).each do |col|
        (0..2).each do |row|
          if @board[row][col] == player && @board[row+1][col] == player &&
             @board[row+2][col] == player && @board[row+3][col] == player
            return true
          end
        end
      end
      false
    end
  
    def check_diagonal(player)
      # Check diagonal down-right
      (0..2).each do |row|
        (0..3).each do |col|
          if @board[row][col] == player && @board[row+1][col+1] == player &&
             @board[row+2][col+2] == player && @board[row+3][col+3] == player
            return true
          end
        end
      end
  
      # Check diagonal down-left
      (0..2).each do |row|
        (3..6).each do |col|
          if @board[row][col] == player && @board[row+1][col-1] == player &&
             @board[row+2][col-2] == player && @board[row+3][col-3] == player
            return true
          end
        end
      end
  
      false
    end
  end