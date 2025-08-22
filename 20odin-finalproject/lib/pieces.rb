
class Piece
    attr_reader :color
  
    def initialize(color)
      @color = color
    end
  
    def valid_move?(board, from, to)
      return false unless board.valid_position?(to)
      return false if from == to
      
      target_piece = board.get_piece(to)
      return false if target_piece && target_piece.color == @color
      
      possible_moves(board, from).include?(to)
    end
  
    def to_s
      # Unicode символы для шахматных фигур
      case self.class.to_s
      when 'Pawn'   then @color == :white ? '♙' : '♟'
      when 'Rook'   then @color == :white ? '♖' : '♜'
      when 'Knight' then @color == :white ? '♘' : '♞'
      when 'Bishop' then @color == :white ? '♗' : '♝'
      when 'Queen'  then @color == :white ? '♕' : '♛'
      when 'King'   then @color == :white ? '♔' : '♚'
      else ' '
      end
    end
  end
  
  class Pawn < Piece
    def possible_moves(board, position)
      moves = []
      row, col = position
      direction = @color == :white ? -1 : 1
      
      # Ход вперед
      forward = [row + direction, col]
      if board.valid_position?(forward) && board.get_piece(forward).nil?
        moves << forward
        
        # Двойной ход с начальной позиции
        if (@color == :white && row == 6) || (@color == :black && row == 1)
          double_forward = [row + 2 * direction, col]
          moves << double_forward if board.get_piece(double_forward).nil?
        end
      end
      
      # Взятие по диагонали
      [[direction, -1], [direction, 1]].each do |dr, dc|
        capture_pos = [row + dr, col + dc]
        if board.valid_position?(capture_pos)
          target = board.get_piece(capture_pos)
          moves << capture_pos if target && target.color != @color
        end
      end
      
      moves.select { |pos| board.valid_position?(pos) }
    end
  end
  
  class Rook < Piece
    def possible_moves(board, position)
      horizontal_vertical_moves(board, position)
    end
  
    private
  
    def horizontal_vertical_moves(board, position)
      moves = []
      row, col = position
      
      # Горизонтальные и вертикальные направления
      directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
      
      directions.each do |dr, dc|
        current_row, current_col = row + dr, col + dc
        
        while board.valid_position?([current_row, current_col])
          target = board.get_piece([current_row, current_col])
          
          if target.nil?
            moves << [current_row, current_col]
          else
            moves << [current_row, current_col] if target.color != @color
            break
          end
          
          current_row += dr
          current_col += dc
        end
      end
      
      moves
    end
  end
  
  class Knight < Piece
    def possible_moves(board, position)
      moves = []
      row, col = position
      
      # Все возможные L-образные ходы
      knight_moves = [
        [-2, -1], [-2, 1], [-1, -2], [-1, 2],
        [1, -2], [1, 2], [2, -1], [2, 1]
      ]
      
      knight_moves.each do |dr, dc|
        new_pos = [row + dr, col + dc]
        if board.valid_position?(new_pos)
          target = board.get_piece(new_pos)
          moves << new_pos if target.nil? || target.color != @color
        end
      end
      
      moves
    end
  end
  
  class Bishop < Piece
    def possible_moves(board, position)
      diagonal_moves(board, position)
    end
  
    private
  
    def diagonal_moves(board, position)
      moves = []
      row, col = position
      
      # Диагональные направления
      directions = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
      
      directions.each do |dr, dc|
        current_row, current_col = row + dr, col + dc
        
        while board.valid_position?([current_row, current_col])
          target = board.get_piece([current_row, current_col])
          
          if target.nil?
            moves << [current_row, current_col]
          else
            moves << [current_row, current_col] if target.color != @color
            break
          end
          
          current_row += dr
          current_col += dc
        end
      end
      
      moves
    end
  end
  
  class Queen < Piece
    def possible_moves(board, position)
      horizontal_vertical_moves(board, position) + diagonal_moves(board, position)
    end
  
    private
  
    def horizontal_vertical_moves(board, position)
      Rook.new(@color).send(:horizontal_vertical_moves, board, position)
    end
  
    def diagonal_moves(board, position)
      Bishop.new(@color).send(:diagonal_moves, board, position)
    end
  end
  
  class King < Piece
    def possible_moves(board, position)
      moves = []
      row, col = position
      
      # Все соседние клетки
      king_moves = [
        [-1, -1], [-1, 0], [-1, 1],
        [0, -1],           [0, 1],
        [1, -1],  [1, 0],  [1, 1]
      ]
      
      king_moves.each do |dr, dc|
        new_pos = [row + dr, col + dc]
        if board.valid_position?(new_pos)
          target = board.get_piece(new_pos)
          moves << new_pos if target.nil? || target.color != @color
        end
      end
      
      moves
    end
  end