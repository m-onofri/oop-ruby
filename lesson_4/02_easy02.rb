# You are given the following code:

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of calling

oracle = Oracle.new
oracle.predict_the_future

# This code results in a string formed by "You will " and one of the
# available choiches that will be chosen randomly (because in
# predict_the_future the sample method is called).


# We have an Oracle class and a RoadTrip class that inherits from 
# the Oracle class.

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

# This code return a string composed by "You will " and one of the
# phrases defined in the choices method of the RoadTrip class. This 
# is because when choices is called, Ruby looks for this method first
# in the Roadtrip Class; if Ruby can't find a corresponding method here,
# it looks for a choices method in the super-class Oracle.


# How do you find where Ruby will look for a method when that method
# is called? How can you find an object's ancestors?

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

# What is the lookup chain for Orange and HotSauce?

p Orange.ancestors
p HotSauce.ancestors

puts "=" * 50

# What could you add to this class to simplify it and remove two
# methods from the class definition while still maintaining the same 
# functionality?

class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  # def type
  #   @type
  # end

  # def type=(t)
  #   @type = t
  # end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

BeesWax.new("guy").describe_type

puts "=" * 50

# There are a number of variables listed below. What are the 
# different types and how do you know which is which?

#excited_dog = "excited dog"     # => local variable
#@excited_dog = "excited dog"    # => instance variable
#@@excited_dog = "excited dog"   # => class variable


# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# Which one of these is a class method (if any) and how do you 
# know? How would you call a class method?

# Here manufacturer is a class method (because it starts with self),
# while model is an instance method.

# To call a class method -> Television.manufacturer


# If we have a class such as the one below:

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# Explain what the @@cats_count variable does and how it works.
# What code would you need to write to test your theory?

# @@cats_count is a class variable and it will be shared by all the
# instance of Cat class. Specifically, every time an object of Cat
# is instantiated, @@cats_count increment by 1.

puts Cat.cats_count
hercules = Cat.new("Hercules")
patty = Cat.new("Patty")
puts Cat.cats_count

puts "=" * 50

# If we have this class:

class Game
  def play
    "Start the game!"
  end
end

# And another class:

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# What can we add to the Bingo class to allow it to inherit the play
# method from the Game class?


# What are the benefits of using Object Oriented Programming in Ruby?
# Think of as many as you can.

# Better organization of the code
# Creation of interfaces (possibility to expose or not expose parts of the code)
# More abstraction
# Less duplications
# Reusability of previous written code.



