require 'bundler/setup'
require_relative '../main'

module BreakerCheckerLogic
  class PlayerBuilder
    SET = %w[r g b y o p].freeze
    def initialize
      puts " -----------------------------------------------------
      You have chosen to be the Code Builder, put in your
      4 letterded pattern and the computer will try to guess
      within 8 attempts.
       - r for 🔴
       - g for 🟢
       - b for 🔵
       - y for 🟡
       - o for 🟠
       - p for 🟣

       Example response - rgby"
      @code = gets.chomp.downcase.split('')
      @gamekeeper = 0
      @input = [SET.sample, SET.sample, SET.sample, SET.sample]
      @has_this_been_guessed = [@input.join]
      checker
    end

    private

    def checker
      @color_count = Array.new(6)
      SET.each_with_index do |color, index|
        @color_count[index] = @code.tally.key?(color) ? @code.tally[color] : 0
      end
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
      @gamekeeper += 1
      output
    end

    def better_guess
      @better_guess = Array.new(4)
      @temp_helper = SET.sample
      if @run_result.all?(0)
        @input = [SET.sample, SET.sample, SET.sample, SET.sample]
      else
        @run_result.each_with_index do |value, index|
          @better_guess[index] = @input[index] if value == 2
        end
        @run_result.each_with_index do |value, index|
          @temp_helper = @input[index] if value == 1
        end
        @run_result.each_with_index do |value, index|
          @input[index] = if value == 2
                            @better_guess[index]
                          elsif value == 1
                            SET.sample
                          elsif value == 0
                            @temp_helper
                          end
        end
      end
      # puts "Input should be #{@input}"
      # puts "Better guess is #{@better_guess}"
      puts "Temp Helper is #{@temp_helper}"

      if @has_this_been_guessed.include?(@input.join)
        better_guess
      else
        @has_this_been_guessed.push(@input.join)
        checker
      end
    end

    def output
      puts "The computer guessed #{@input}"
      puts "Run Result - #{@run_result}"
      @run_result.each { |value| graphic(value) }
      if @run_result.all?(2)
        puts 'The Computer guessed the code.'
        puts 'If you want to play again press y and hit enter : '
        NewGame.new if gets.chomp.downcase == 'y'
      elsif @gamekeeper < 8
        better_guess
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
