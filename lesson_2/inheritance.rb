# Given this class:

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    "meow"
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"
boss = Bulldog.new
puts boss.swim
herky = Cat.new
puts "Herky is #{herky.jump}"

# One problem is that we need to keep track of different breeds of dogs, since they have slightly 
# different behaviors. For example, bulldogs can't swim, but all other dogs can.
# Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"

# reate a new class called Cat, which can do everything a dog can, except swim or fetch. 
# Assume the methods do the exact same thing. 
# Hint: don't just copy and paste all methods in Dog into Cat; try to come up with some class hierarchy.

# Draw a class hierarchy diagram of the classes from step #2

# Bulldog class hierarchy: Bulldog > Dog > Pet
# Cat class hierarchy: Cat > Pet
