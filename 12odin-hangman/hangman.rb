# frozen_string_literal: true

require 'json'

class Hangman
  MAX_WRONG_GUESSES = 8

  def initialize
    @dictionary = load_dictionary
    @saves_dir = 'saves'
    Dir.mkdir(@saves_dir) unless Dir.exist?(@saves_dir)
  end

  def start
    puts '🎯 ДОБРО ПОЖАЛОВАТЬ В ВИСЕЛИЦУ!'
    puts '1. Новая игра'
    puts '2. Загрузить игру'
    print 'Выберите вариант: '

    case gets.chomp.to_i
    when 1 then new_game
    when 2 then load_game_menu
    else puts 'Неверный выбор!'
         start
    end
  end

  private

  def new_game
    @secret_word = select_random_word.downcase
    @guessed_letters = []
    @wrong_guesses = 0
    @game_state = :playing
    play_round
  end

  def load_dictionary
    File.readlines('google-10000-english-no-swears.txt')
        .map(&:chomp)
        .select { |word| word.length.between?(5, 12) }
  rescue Errno::ENOENT
    puts 'Файл словаря не найден!'
    puts 'Скачайте его: https://github.com/first20hours/google-10000-english'
    exit
  end

  def select_random_word
    @dictionary.sample
  end

  def play_round
    while @game_state == :playing
      display_game_state
      process_turn
      check_game_state
    end

    display_result
    ask_to_play_again
  end

  def display_game_state
    puts "\n#{'=' * 40}"
    puts "Слово: #{display_word}"
    puts "Ошибки: #{@wrong_guesses}/#{MAX_WRONG_GUESSES}"
    puts "Использованные буквы: #{@guessed_letters.sort.join(', ')}"
    draw_hangman if @wrong_guesses.positive?
  end

  def display_word
    @secret_word.chars.map { |char| @guessed_letters.include?(char) ? char : '_' }.join(' ')
  end

  def draw_hangman
    stages = [
      # 0 ошибок - пусто
      '',
      # 1 ошибка
      "   ____\n  |    |\n  |    \n  |   \n  |    \n__|__",
      # 2 ошибки
      "   ____\n  |    |\n  |    O\n  |   \n  |    \n__|__",
      # 3 ошибки
      "   ____\n  |    |\n  |    O\n  |    |\n  |    \n__|__",
      # 4 ошибки
      "   ____\n  |    |\n  |    O\n  |   /|\n  |    \n__|__",
      # 5 ошибки
      "   ____\n  |    |\n  |    O\n  |   /|\\\n  |    \n__|__",
      # 6 ошибки
      "   ____\n  |    |\n  |    O\n  |   /|\\\n  |   / \n__|__",
      # 7 ошибки
      "   ____\n  |    |\n  |    O\n  |   /|\\\n  |   / \\\n__|__"
    ]
    puts stages[@wrong_guesses]
  end

  def process_turn
    print "\nВведите букву или 'save' для сохранения: "
    input = gets.chomp.downcase

    if input == 'save'
      save_game
      puts 'Игра сохранена!'
      return
    end

    if valid_input?(input)
      letter = input[0]
      if @guessed_letters.include?(letter)
        puts 'Вы уже угадывали эту букву!'
      else
        @guessed_letters << letter
        unless @secret_word.include?(letter)
          @wrong_guesses += 1
          puts "Буквы '#{letter}' нет в слове!"
        end
      end
    else
      puts "Введите одну букву или 'save'!"
    end
  end

  def valid_input?(input)
    input.length == 1 && input.match?(/[a-zа-я]/i)
  end

  def check_game_state
    if @wrong_guesses >= MAX_WRONG_GUESSES
      @game_state = :lost
    elsif @secret_word.chars.all? { |char| @guessed_letters.include?(char) }
      @game_state = :won
    end
  end

  def display_result
    puts "\n#{'=' * 40}"
    if @game_state == :won
      puts "🎉 ПОБЕДА! Вы угадали слово: #{@secret_word.upcase}"
    else
      puts "💀 ПРОИГРЫШ! Загаданное слово: #{@secret_word.upcase}"
      draw_hangman
    end
  end

  def ask_to_play_again
    print "\nХотите сыграть еще раз? (y/n): "
    if gets.chomp.downcase == 'y'
      new_game
    else
      puts 'Спасибо за игру!'
      exit
    end
  end

  def save_game
    save_data = {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      wrong_guesses: @wrong_guesses,
      timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    }

    filename = "#{@saves_dir}/hangman_#{Time.now.to_i}.json"
    File.write(filename, JSON.pretty_generate(save_data))
    filename
  end

  def load_game_menu
    saves = Dir["#{@saves_dir}/*.json"]

    if saves.empty?
      puts 'Нет сохраненных игр!'
      start
      return
    end

    puts "\nСОХРАНЕННЫЕ ИГРЫ:"
    saves.each_with_index do |save, index|
      data = JSON.parse(File.read(save))
      puts "#{index + 1}. #{File.basename(save)} - #{data['timestamp']}"
    end

    print 'Выберите игру для загрузки: '
    choice = gets.chomp.to_i - 1

    if choice.between?(0, saves.size - 1)
      load_game(saves[choice])
    else
      puts 'Неверный выбор!'
      load_game_menu
    end
  end

  def load_game(filename)
    data = JSON.parse(File.read(filename))
    @secret_word = data['secret_word']
    @guessed_letters = data['guessed_letters']
    @wrong_guesses = data['wrong_guesses']
    @game_state = :playing

    puts 'Игра загружена!'
    play_round
  end
end

# Запуск игры
if __FILE__ == $PROGRAM_NAME
  # Скачиваем словарь если его нет
  unless File.exist?('google-10000-english-no-swears.txt')
    puts 'Скачиваем словарь...'
    system('curl -O https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt')
  end

  game = Hangman.new
  game.start
end
