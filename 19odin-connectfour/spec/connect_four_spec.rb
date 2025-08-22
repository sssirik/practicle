# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe ConnectFour do
  let(:game) { ConnectFour.new }

  describe '#initialize' do
    it 'creates a 6x7 empty board' do
      expect(game.board.size).to eq(6)
      expect(game.board.all? { |row| row.size == 7 }).to be true
      expect(game.board.flatten.all?(&:nil?)).to be true
    end

    it 'starts with player 1' do
      expect(game.current_player).to eq(1)
    end
  end

  describe '#drop_piece' do
    context 'with valid column' do
      it 'places piece in the bottom of empty column' do
        expect(game.drop_piece(0)).to be true
        expect(game.board[5][0]).to eq(1)
      end

      it 'stacks pieces in the same column' do
        game.drop_piece(0)
        game.switch_player
        game.drop_piece(0)
        
        expect(game.board[5][0]).to eq(1)
        expect(game.board[4][0]).to eq(2)
      end
    end

    context 'with invalid column' do
      it 'returns false for column out of bounds' do
        expect(game.drop_piece(-1)).to be false
        expect(game.drop_piece(7)).to be false
      end

      it 'returns false for full column' do
        6.times { game.drop_piece(0) }
        expect(game.drop_piece(0)).to be false
      end
    end
  end

  describe '#switch_player' do
    it 'switches from player 1 to player 2' do
      game.switch_player
      expect(game.current_player).to eq(2)
    end

    it 'switches from player 2 to player 1' do
      game.instance_variable_set(:@current_player, 2)
      game.switch_player
      expect(game.current_player).to eq(1)
    end
  end

  describe '#winner?' do
    context 'horizontal win' do
      it 'detects horizontal win for player 1' do
        [0, 1, 2, 3].each { |col| game.drop_piece(col) }
        expect(game.winner?(1)).to be true
      end

      it 'detects horizontal win for player 2' do
        game.instance_variable_set(:@current_player, 2)
        [0, 1, 2, 3].each { |col| game.drop_piece(col) }
        expect(game.winner?(2)).to be true
      end
    end

    context 'vertical win' do
      it 'detects vertical win' do
        4.times { game.drop_piece(0) }
        expect(game.winner?(1)).to be true
      end
    end

    context 'diagonal win' do
      it 'detects diagonal down-right win' do
        # Setup for diagonal win
        moves = [
          [0, 1], [1, 2], [1, 1], [2, 2], 
          [2, 1], [3, 2], [2, 1], [3, 2],
          [3, 1], [0, 2], [3, 1]
        ]
        
        moves.each do |col, player|
          game.instance_variable_set(:@current_player, player)
          game.drop_piece(col)
        end
        
        expect(game.winner?(1)).to be true
      end
    end

    context 'no win' do
      it 'returns false when no win condition' do
        expect(game.winner?(1)).to be false
        expect(game.winner?(2)).to be false
      end
    end
  end

  describe '#board_full?' do
    it 'returns false for empty board' do
      expect(game.board_full?).to be false
    end

    it 'returns true for full board' do
      # Fill the board
      7.times do |col|
        6.times do
          game.drop_piece(col)
          game.switch_player
        end
      end
      
      expect(game.board_full?).to be true
    end
  end

  describe '#print_board' do
    it 'does not raise error' do
      expect { game.print_board }.not_to raise_error
    end
  end
end