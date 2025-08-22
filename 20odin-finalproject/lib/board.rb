
class Board
    attr_reader :grid
  
    def initialize
      @grid = Array.new(8) { Array.new(8) }
    end
  
    def place_piece(type, color, position)
      row, col = position
      @grid[row][col] = case type
                       when :pawn   then Pawn.new(color)
                       when :rook   then Rook.new(color)
                       when :knight then Knight.new(color)
                       when :bishop then Bishop.new(color)
                       when :queen  then Queen.new(color)
                       when :king   then King.new(color)
                       end
    end
  
    def get_piece(position)
      row, col = position
      @grid[row][col]
    end
  
    def move_piece(from, to)
      from_row, from_col = from
      to_row, to_col = to
      
      @grid[to_row][to_col] = @grid[from_row][from_col]
      @grid[from_row][from_col] = nil
    end
  
    def pieces(color)
      result = []
      @grid.each_with_index do |row, i|
        row.each_with_index do |piece, j|
          result << [piece, [i, j]] if piece && piece.color == color
        end
      end
      result
    end
  
    def serialize
      serialized_grid = @grid.map do |row|
        row.map do |piece|
          piece ? { type: piece.class.to_s.downcase.to_sym, color: piece.color } : nil
        end
      end
      { grid: serialized_grid }
    end
  
    def self.deserialize(data)
      board = Board.new
      data[:grid].each_with_index do |row, i|
        row.each_with_index do |piece_data, j|
          next unless piece_data
          board.place_piece(piece_data[:type], piece_data[:color], [i, j])
        end
      end
      board
    end
  
    def valid_position?(position)
      row, col = position
      row.between?(0, 7) && col.between?(0, 7)
    end
  end