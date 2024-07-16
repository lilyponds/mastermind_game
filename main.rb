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

  def decider
    if @decider == 1
      @play = CodeBreakerChecker.new
    elsif @decider == 2
      @play = CodeBuilderChecker.new
    end
  end
end
