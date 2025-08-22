
require 'yaml'

class ChessGame
  attr_reader :board, :current_player, :move_history

  def initialize
    @board = Board.new
    @current_player = :white
    @move_history = []
    setup_board
  end

  def setup_board
    # Расстановка фигур
    pieces = {
      white: {
        pawn:   (0..7).map { |col| [6, col] },
        rook:   [[7, 0], [7, 7]],
        knight: [[7, 1], [7, 6]],
        bishop: [[7, 2], [7, 5]],
        queen:  [[7, 3]],
        king:   [[7, 4]]
      },
      black: {
        pawn:   (0..7).map { |col| [1, col] },
        rook:   [[0, 0], [0, 7]],
        knight: [[0, 1], [0, 6]],
        bishop: [[0, 2], [0, 5]],
        queen:  [[0, 3]],
        king:   [[0, 4]]
      }
    }

    pieces.each do |color, piece_types|
      piece_types.each do |type, positions|
        positions.each do |pos|
          @board.place_piece(type, color, pos)
        end
      end
    end
  end

  def make_move(move_notation)
    from, to = parse_notation(move_notation)
    return false unless from && to

    piece = @board.get_piece(from)
    return false unless piece && piece.color == @current_player

    if piece.valid_move?(@board, from, to)
      # Сохраняем состояние до хода
      captured_piece = @board.get_piece(to)
      
      # Выполняем ход
      @board.move_piece(from, to)
      @move_history << { from: from, to: to, piece: piece.class, captured: captured_piece&.class }
      
      # Проверяем, не подставил ли игрок себя под шах
      if in_check?(@current_player)
        # Отменяем ход
        @board.move_piece(to, from)
        @board.place_piece(captured_piece.class, captured_piece.color, to) if captured_piece
        @move_history.pop
        return false
      end

      true
    else
      false
    end
  end

  def parse_notation(notation)
    return nil unless notation.match?(/^[a-h][1-8]-[a-h][1-8]$/)
    
    from_str, to_str = notation.split('-')
    [chess_to_coords(from_str), chess_to_coords(to_str)]
  end

  def chess_to_coords(chess_notation)
    col = chess_notation[0].ord - 'a'.ord
    row = 8 - chess_notation[1].to_i
    [row, col]
  end

  def coords_to_chess(coords)
    row, col = coords
    "#{('a'.ord + col).chr}#{8 - row}"
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_color = color == :white ? :black : :white

    @board.pieces(opponent_color).any? do |piece, pos|
      piece.valid_move?(@board, pos, king_pos)
    end
  end

  def check?
    in_check?(@current_player)
  end

  def checkmate?
    return false unless check?
    
    # Проверяем, есть ли любой допустимый ход
    @board.pieces(@current_player).none? do |piece, pos|
      piece.possible_moves(@board, pos).any? do |move|
        # Пробуем ход
        captured = @board.get_piece(move)
        @board.move_piece(pos, move)
        
        still_in_check = in_check?(@current_player)
        
        # Отменяем ход
        @board.move_piece(move, pos)
        @board.place_piece(captured.class, captured.color, move) if captured
        
        !still_in_check
      end
    end
  end

  def stalemate?
    return false if check?
    
    # Проверяем, есть ли любой допустимый ход
    @board.pieces(@current_player).none? do |piece, pos|
      piece.possible_moves(@board, pos).any? do |move|
        # Пробуем ход
        captured = @board.get_piece(move)
        @board.move_piece(pos, move)
        
        still_in_check = in_check?(@current_player)
        
        # Отменяем ход
        @board.move_piece(move, pos)
        @board.place_piece(captured.class, captured.color, move) if captured
        
        !still_in_check
      end
    end
  end

  def game_over?
    checkmate? || stalemate?
  end

  def switch_player
    @current_player = @current_player == :white ? :black : :white
  end

  def find_king(color)
    @board.grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece.is_a?(King) && piece.color == color
      end
    end
    nil
  end

  def display_board
    puts "  a b c d e f g h"
    puts "  ┌───────────────┐"
    
    @board.grid.each_with_index do |row, i|
      print "#{8 - i}│ "
      row.each do |piece|
        symbol = piece ? piece.to_s : ' '
        print "#{symbol} "
      end
      puts "│#{8 - i}"
    end
    
    puts "  └───────────────┘"
    puts "  a b c d e f g h"
  end

  def save_game
    data = {
      board: @board.serialize,
      current_player: @current_player,
      move_history: @move_history
    }
    
    File.open('chess_save.yaml', 'w') { |file| file.write(data.to_yaml) }
  end

  def load_game
    return unless File.exist?('chess_save.yaml')
    
    data = YAML.load_file('chess_save.yaml')
    @board = Board.deserialize(data[:board])
    @current_player = data[:current_player]
    @move_history = data[:move_history]
  end
end