# frozen_string_literal: true

def knight_moves(start, target)
    # Проверка на валидность входных данных
    return nil unless valid_position?(start) && valid_position?(target)
    return [start] if start == target
  
    # Возможные ходы коня
    moves = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ]
  
    # Очередь для BFS: [position, path]
    queue = [[start, [start]]]
    visited = { start => true }
  
    until queue.empty?
      current_pos, path = queue.shift
  
      # Проверяем все возможные ходы
      moves.each do |move|
        new_pos = [current_pos[0] + move[0], current_pos[1] + move[1]]
  
        # Пропускаем невалидные позиции и уже посещенные
        next unless valid_position?(new_pos) && !visited[new_pos]
  
        new_path = path + [new_pos]
        
        # Если достигли цели
        if new_pos == target
          print_result(new_path)
          return new_path
        end
  
        # Добавляем в очередь и отмечаем как посещенное
        visited[new_pos] = true
        queue << [new_pos, new_path]
      end
    end
  
    nil # Если путь не найден
  end
  
  def valid_position?(pos)
    # Проверяем, что позиция в пределах доски 8x8
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end
  
  def print_result(path)
    puts "You made it in #{path.size - 1} moves! Here's your path:"
    path.each { |pos| puts "  #{pos}" }
  end
  
  # Тестирование
  if __FILE__ == $0
    puts "knight_moves([0,0],[1,2]):"
    knight_moves([0, 0], [1, 2])
    puts "\nknight_moves([0,0],[3,3]):"
    knight_moves([0, 0], [3, 3])
    puts "\nknight_moves([3,3],[0,0]):"
    knight_moves([3, 3], [0, 0])
    puts "\nknight_moves([0,0],[7,7]):"
    knight_moves([0, 0], [7, 7])
    puts "\nknight_moves([3,3],[4,3]):"
    knight_moves([3, 3], [4, 3])
  end