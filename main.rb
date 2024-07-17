require 'bundler/setup'
require_relative 'lib/codebreaker'
require_relative 'lib/codebuilder'

class NewGame
  include BuilderCheckerLogic
  include BreakerCheckerLogic

  def initialize
    puts " -----------------------------------------------------
    Welcome to Mastermind
    Press 1 if you want to be the CodeBreaker
    Press 2 if you want to be the CodeBuilder
    "
    @decider = gets.chomp.to_i
    decider
  end

  private

  def decider
    if @decider == 1
      @play = PlayerBreaker.new
    elsif @decider == 2
      @play = PlayerBuilder.new
    end
  end
end
