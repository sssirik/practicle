# frozen_string_literal: true

class Mastermind
  COLORS = %w[R G B Y P O].freeze # Красный, Зеленый, Синий, Желтый, Фиолетовый, Оранжевый
  CODE_LENGTH = 4
  MAX_ATTEMPTS = 12

  def initialize
    puts 'Добро пожаловать в Mastermind!'
    puts 'Цвета: R(красный), G(зеленый), B(синий), Y(желтый), P(фиолетовый), O(оранжевый)'
    puts 'Код состоит из 4 цветов. Пример: RGBY'
  end

  def play
    role = choose_role
    if role == 1
      play_as_guesser
    else
      play_as_maker
    end
  end

  private

  def choose_role
    puts "\nВыберите роль:"
    puts '1 - Угадывающий (компьютер загадывает код)'
    puts '2 - Загадывающий (вы загадываете код)'
    print 'Ваш выбор (1 или 2): '
    gets.chomp.to_i
  end

  def play_as_guesser
    secret_code = generate_code
    attempts = 0

    puts "\nКомпьютер загадал код. У вас #{MAX_ATTEMPTS} попыток!"

    MAX_ATTEMPTS.times do |attempt|
      attempts = attempt + 1
      puts "\nПопытка #{attempts}/#{MAX_ATTEMPTS}"

      guess = get_player_guess
      feedback = evaluate_guess(guess, secret_code)

      display_feedback(guess, feedback)

      if guess == secret_code
        puts "🎉 Поздравляем! Вы угадали код за #{attempts} попыток!"
        return
      end
    end

    puts "💀 Вы проиграли! Секретный код был: #{secret_code.join}"
  end

  def play_as_maker
    secret_code = get_secret_code_from_player
    attempts = 0
    possible_codes = generate_all_possible_codes

    puts "\nКомпьютер пытается угадать ваш код..."

    MAX_ATTEMPTS.times do |attempt|
      attempts = attempt + 1
      computer_guess = computer_make_guess(possible_codes)

      puts "\nПопытка #{attempts}: #{computer_guess.join}"

      feedback = evaluate_guess(computer_guess, secret_code)
      display_feedback(computer_guess, feedback)

      if computer_guess == secret_code
        puts "🤖 Компьютер угадал ваш код за #{attempts} попыток!"
        return
      end

      # Уточняем возможные коды на основе feedback
      possible_codes.select! do |code|
        evaluate_guess(computer_guess, code) == feedback
      end
    end

    puts '🎯 Компьютер не смог угадать ваш код! Вы победили!'
  end

  def generate_code
    CODE_LENGTH.times.map { COLORS.sample }
  end

  def get_player_guess
    loop do
      print 'Введите ваш guess (4 цвета, например: RGBY): '
      input = gets.chomp.upcase

      return input.chars if valid_guess?(input)

      puts "Неверный ввод! Используйте только цвета: #{COLORS.join(', ')}"
    end
  end

  def get_secret_code_from_player
    loop do
      print 'Загадайте код (4 цвета, например: RGBY): '
      input = gets.chomp.upcase

      return input.chars if valid_guess?(input)

      puts "Неверный ввод! Используйте только цвета: #{COLORS.join(', ')}"
    end
  end

  def valid_guess?(input)
    input.length == CODE_LENGTH && input.chars.all? { |c| COLORS.include?(c) }
  end

  def evaluate_guess(guess, secret_code)
    exact_matches = 0
    color_matches = 0

    # Проверяем точные совпадения
    temp_guess = guess.dup
    temp_secret = secret_code.dup

    # Сначала считаем точные совпадения
    CODE_LENGTH.times do |i|
      next unless temp_guess[i] == temp_secret[i]

      exact_matches += 1
      temp_guess[i] = nil
      temp_secret[i] = nil
    end

    # Затем считаем совпадения цветов в неправильных позициях
    temp_guess.compact!
    temp_secret.compact!

    temp_guess.each do |color|
      if temp_secret.include?(color)
        color_matches += 1
        temp_secret.delete_at(temp_secret.index(color))
      end
    end

    [exact_matches, color_matches]
  end

  def display_feedback(guess, feedback)
    exact, color = feedback
    puts "Guess: #{guess.join} | ✅ Точных: #{exact}, 🎨 Цветов: #{color}"
  end

  def generate_all_possible_codes
    COLORS.repeated_permutation(CODE_LENGTH).to_a
  end

  def computer_make_guess(possible_codes)
    possible_codes.sample
  end
end

# Запуск игры
if __FILE__ == $PROGRAM_NAME
  game = Mastermind.new
  game.play
end
