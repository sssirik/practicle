
require_relative '../lib/chess_game'
require_relative '../lib/board'
require_relative '../lib/pieces'

RSpec.describe ChessGame do
  let(:game) { ChessGame.new }

  describe '#make_move' do
    it 'allows valid pawn move' do
      expect(game.make_move('e2-e4')).to be true
    end

    it 'rejects invalid move' do
      expect(game.make_move('e2-e5')).to be false
    end

    it 'switches player after valid move' do
      initial_player = game.current_player
      game.make_move('e2-e4')
      expect(game.current_player).not_to eq(initial_player)
    end
  end

  describe '#check?' do
    it 'detects check situation' do
      # Создаем ситуацию с шахом
      game.instance_variable_get(:@board).grid[7][4] = nil # Убираем белого короля
      game.instance_variable_get(:@board).grid[3][4] = King.new(:white)
      game.instance_variable_get(:@board).grid[2][4] = Queen.new(:black)
      
      expect(game.check?).to be true
    end
  end

  describe '#save_game and #load_game' do
    it 'saves and loads game state' do
      game.make_move('e2-e4')
      game.save_game
      
      new_game = ChessGame.new
      new_game.load_game
      
      expect(new_game.current_player).to eq(game.current_player)
      expect(new_game.instance_variable_get(:@board).grid).to eq(game.instance_variable_get(:@board).grid)
    end
  end
end

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#move_piece' do
    it 'moves piece correctly' do
      piece = Pawn.new(:white)
      board.place_piece(:pawn, :white, [6, 0])
      board.move_piece([6, 0], [5, 0])
      
      expect(board.get_piece([5, 0])).to be_a(Pawn)
      expect(board.get_piece([6, 0])).to be_nil
    end
  end
end

RSpec.describe Piece do
  describe Pawn do
    let(:pawn) { Pawn.new(:white) }
    let(:board) { Board.new }

    it 'moves forward correctly' do
      board.place_piece(:pawn, :white, [6, 0])
      moves = pawn.possible_moves(board, [6, 0])
      
      expect(moves).to include([5, 0])
      expect(moves).to include([4, 0])
    end
  end
end