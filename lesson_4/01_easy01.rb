# Which of the following are objects in Ruby? If they are objects,
# how can you find out what class they belong to?

# true
# "hello"
# [1, 2, 3, "happy days"]
# 142

# All of them are objects. Yo can find out what class they belong to
# calling the method class on each object:

puts true.class
puts "hello".class
puts [1, 2, 3, "happy days"].class
puts 142.class

puts "=" * 50

# If we have a Car class and a Truck class and we want to be able to
# go_fast, how can we add the ability for them to go_fast using the
# module Speed? How can you check if your Car or Truck can now go fast?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

fiesta = Car.new
super_truck = Truck.new

fiesta.go_fast
super_truck.go_fast


puts "=" * 50

# In the last question we had a module called Speed which contained
# a go_fast method. 
# When we called the go_fast method from an instance of the Car 
# class (as shown below) you might have noticed that the string 
# printed when we go fast includes the name of the type of vehicle 
# we are using. How is this done?

# This is possible because inside the go_fast method in the Speed 
# module the class method is called (the class method comes from the 
# the Object Class). Specifically, it is called on
# an instantiation on the object where this method is executed; in
# fact the class method is called on the key word self.


# If we have a class AngryCat how do we create a new instance of 
# this class?

# The AngryCat class might look something like this:

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

# You can create a new instance of the AngryCat Class using the method
# new: AngryCat.new


# Which of these two classes has an instance variable and how do you
# know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The class called Pizza has an instance variable, specifically @name.
# It's easy to recognize an instance variable because it always starts
# with @.
# To be sure, you can also run the method instance_variables (from the
# Object Class) on the object like this:
margherita = Pizza.new("margherita")
p margherita.instance_variables

puts "=" * 50

# What could we add to the class below to access the instance variable 
# @volume?

class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end

  #def volume
  #  @volume
  #end
end

# To access @volume we need either a getter method like the volume 
# method above or setting the attr_reader with a corresponding 
# symbol (in this case :volume)

cube = Cube.new(3)
puts cube.volume

puts "=" * 50

# What is the default thing that Ruby will print to the screen if 
# you call to_s on an object? Where could you go to find out if you want to be sure?

# By default Ruby prints the class name of the object followed by 
# the object id


# If we have a class such as the one below:

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# You can see in the make_one_year_older method we have used self.
# What does self refer to here?

# Here self refers to the object (the calling object) that will be
# initialized from the class Cat


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

# In the name of the cats_count method we have used self.
# What does self refer to in this context?

# cats_count is a class method and self refers to the class Cat


# If we have the class below, what would you need to call to create
# a new instance of this class.

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

device = Bag.new("black", "leather")

















