require 'bundler/setup'

class CodeBuilder
  SET = %w[r g b y o p].freeze

  def initialize
    puts " -----------------------------------------------------
    Welcome to Mastermind
    Put in your guess code and use first alphabets of the colors
     - r for 🔴
     - g for 🟢
     - b for 🔵
     - y for 🟡
     - o for 🟠
     - p for 🟣

     Example response - rgby
     You get 8 attempts in total."
    @code = [SET.sample, SET.sample, SET.sample, SET.sample]
    @gamekeeper = 0

    # count of all colors in the actual code, as an array
    @code_color_tab = Array.new(6)
    # create a tab for number of times a color appears in the actual code and store it as an array
    # that is inline with the sequence in SET
    #--------
    # opro => [1,0,0,0,2,1] -> Incorrect hints when inputted poor exp[1111] vs act[1100]
    #------
    SET.each_with_index do |color, index|
      @code_color_tab[index] = @code.tally.key?(color) ? @code.tally[color] : 0
    end
    user_input
  end

  private

  def user_input
    puts 'Enter your guess : '
    # p o o r
    @input = gets.chomp.downcase.split('')
    @gamekeeper += 1
    checker
  end

  def checker
    # make a copy of color tabs to check for partial matches
    @color_count = @code_color_tab
    @run_result = Array.new(4, 0)
    # first check if there is perfect color + position guess
    @input.each_with_index do |color, index|
      if @code[index] == color
        @run_result[index] = 2
        @color_count[SET.index(color)] -= 1
      end
    end
    # now check if there is a color match
    @run_result.each_with_index do |value, index|
      if value < 2
        if (@color_count[SET.index(@input[index])]).positive?
          @run_result[index] = 1
          @color_count[SET.index(@input[index])] -= 1
        else
          @run_result[index] = 0
        end
      end
    end
    output
  end

  def output
    @run_result.each { |value| graphic(value) }
    if @run_result.all?(2)
      puts 'Winner Winner, you did it!'
      puts 'If you want to play again press y and hit enter : '
      initialize if gets.chomp.downcase == 'y'
    elsif @gamekeeper < 9
      user_input
    else
      puts 'Maximum attempts reached, Game Over!'
      puts 'If you want to play again press y and hit enter : '
      initialize if gets.chomp.downcase == 'y'
    end
  end

  def graphic(value)
    case value
    when 0
      puts '⛔️'
    when 1
      puts '💡'
    when 2
      puts '✅'
    end
  end
end
