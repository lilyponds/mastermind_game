require 'bundler/setup'

module BreakerCheckerLogic
  class CodeBuilderChecker
    SET = %w[r g b y o p].freeze
    def initialize
      puts " -----------------------------------------------------
      You have chosen to be the Code Builder, put in your 4 letterded desired pattern and the computer will try to guess
      within 8 attempts.
       - r for 🔴
       - g for 🟢
       - b for 🔵
       - y for 🟡
       - o for 🟠
       - p for 🟣

       Example response - rgby"
      @code = gets.chomp.downcase.split
      @color_count = Array.new(6)
      SET.each_with_index do |color, index|
        @color_count[index] = @code.tally.key?(color) ? @code.tally[color] : 0
      end
      @gamekeeper = 0
      computer_guess
    end

    # Need to add logic for computer to guess better.
    def computer_guess
      @input = [SET.sample, SET.sample, SET.sample, SET.sample]
      puts "The computer guessed #{@input}"
      @gamekeeper += 1
      checker
    end

    # need to be modified
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
        initialize if gets.chomp.downcase == 'y'
      elsif @gamekeeper < 9
        computer_guess
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
end
