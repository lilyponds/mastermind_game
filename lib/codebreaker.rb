require 'bundler/setup'
require_relative '../main'

module BuilderCheckerLogic
  class PlayerBreaker
    SET = %w[r g b y o p].freeze

    def initialize
      puts " -----------------------------------------------------
      You have chosen to be the Code Breaker, the computer has created a pattern -
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
      user_input
    end

    private

    def user_input
      # create a tab for number of times a color appears in the actual code and store it as an array
      # that is inline with the sequence in SET
      @color_count = Array.new(6)
      SET.each_with_index do |color, index|
        @color_count[index] = @code.tally.key?(color) ? @code.tally[color] : 0
      end
      puts 'Enter your guess : '
      @input = gets.chomp.downcase.split('')
      @gamekeeper += 1
      checker
    end

    def checker
      @run_result = Array.new(4, 0)
      # first check if there is perfect color + position guess
      @input.each_with_index do |color, index|
        next unless @code[index] == color

        @run_result[index] = 2
        # If there is a match, reduce the value associated to that color in our colors_tab by 1,
        # meaning, one occurence of the number is accounted for in the current input
        @color_count[SET.index(color)] -= 1
      end
      # now check if there is a color guess but in the wrong position
      @run_result.each_with_index do |value, index|
        if value < 2
          if (@color_count[SET.index(@input[index])]).positive?
            @run_result[index] = 1
            # If there is a match, reduce the value associated to that color in our colors_tab by 1,
            # meaning, one occurence of the number is accounted for in the current input
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
        NewGame.new if gets.chomp.downcase == 'y'
      elsif @gamekeeper < 9
        user_input
      else
        puts 'Maximum attempts reached, Game Over!'
        puts 'If you want to play again press y and hit enter : '
        NewGame.new if gets.chomp.downcase == 'y'
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
end
