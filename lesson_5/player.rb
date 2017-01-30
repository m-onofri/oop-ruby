require_relative 'modules'

class Player
  include Displayable

  attr_reader :name

  def initialize
    @name = set_name
  end
end

class Human < Player
  def set_name
    user_name = ''
    prompt "Please, enter your name:"
    loop do
      user_name = gets.chomp
      break if user_name =~ /^[A-Za-z0-9]+$/
      prompt "Please enter a valid name:"
    end
    user_name
  end
end

class Computer < Player
  def set_name
    %w(R2D2 Hal Chappie Sonnie Number5).sample
  end
end
