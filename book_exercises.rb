# Create a class called MyCar. When you initialize a new instance or object of the class, allow the 
# user to define some instance variables that tell us the year, color, and model of the car. 
# Create an instance variable that is set to 0 during instantiation of the object to track the current speed 
# of the car as well. Create instance methods that allow the car to speed up, brake, and shut the car off.

# Add an accessor method to your MyCar class to change and view the color of your car. 
# Then add an accessor method that allows you to view, but not modify, the year of your car.

# You want to create a nice interface that allows you to accurately describe the action you want your 
# program to perform. Create a method called spray_paint that can be called on an object and will modify 
# the color of the car.

# Add a class method to your MyCar class that calculates the gas mileage of any car.

# Override the to_s method to create a user friendly print out of your object.

# class MyCar
#   attr_accessor :color
#   attr_reader :year

#   def initialize(year, color, model)
#     @year = year
#     @color = color
#     @model = model
#     @speed = 0
#   end

#   def self.gas_mileage(litri, chilometri)
#     puts "#{chilometri / litri} kilometers per liter of gas"
#   end

#   def speed_up(number)
#     @speed += number
#     puts "You accelerate #{number} mph."
#   end

#   def brake(number)
#     @speed -= number
#     puts "You decelerate #{number} mph."
#   end

#   def shut_down
#     @speed = 0
#     puts "You shut down the car."
#   end

#   def current_speed
#     puts "You're now going #{@speed} mph."
#   end

#   def spray_paint(new_color)
#     self.color = new_color
#     puts "You change the color of the car to #{@color}."
#   end

#   def to_s
#     "This car is a #{@year} #{@color} #{@model}"
#   end
# end

# panda = MyCar.new(2006, "black", "fiat panda")
# puts panda.color
# panda.spray_paint("white")
# puts panda.color
# puts panda.year
# MyCar.gas_mileage(20, 2000)

# puts panda


# Create a superclass called Vehicle for your MyCar class to inherit from and move the behavior that isn't 
# specific to the MyCar class to the superclass. Create a constant in your MyCar class that stores 
# information about the vehicle that makes it different from other types of Vehicles.

# Then create a new class called MyTruck that inherits from your superclass that also has a constant 
# defined that separates it from the MyCar class in some way.

# Add a class variable to your superclass that can keep track of the number of objects created that 
# inherit from the superclass. Create a method to print out the value of this class variable as well.

# Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to 
# that subclass.

# Print to the screen your method lookup for the classes that you have created.

# Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle 
# class. Make sure that all of your previous method calls are working when you are finished.

# Write a method called age that calls a private method to calculate the age of the vehicle. 
# Make sure the private method is not available from outside of the class. You'll need to use 
# Ruby's built-in Time class to help.

module Customizable
  def spray_paint(new_color)
    self.color = new_color
    puts "You change the color of the vehicle to #{@color}."
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year

  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @@number_of_vehicles += 1
    @speed = 0
  end

  def speed_up(number)
    @speed += number
    puts "You accelerate #{number} mph."
  end

  def brake(number)
    @speed -= number
    puts "You decelerate #{number} mph."
  end

  def shut_down
    @speed = 0
    puts "You shut down the car."
  end

  def current_speed
    puts "You're now going #{@speed} mph."
  end

  def vehicle_age
    puts "This vehicle is #{age} years old."
  end

  def self.gas_mileage(litri, chilometri)
    puts "#{chilometri / litri} kilometers per liter of gas"
  end

  def self.count_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles."
  end

  private

  def age
    current_year = Time.new.year
    car_age = current_year - @year 
  end
end

class MyCar < Vehicle
  include Customizable

  NUMBER_OF_DOORS = 4

  def to_s
    "This car is a #{@year} #{@color} #{@model}"
  end
end

class MyTruck < Vehicle
  NUMBER_OF_DOORS = 2
end

#puts MyCar.ancestors
#puts "-" * 80
#puts MyTruck.ancestors

bolide = MyCar.new(2006, "black", "Fiat panda")
bolide.speed_up(50)
bolide.current_speed
bolide.brake(16)
bolide.current_speed
bolide.shut_down
bolide.current_speed
Vehicle.gas_mileage(100, 1000)
Vehicle.count_vehicles
bolide.vehicle_age


# Create a class 'Student' with attributes name and grade. Do NOT make the grade getter public, 
# so joe.grade will raise an error. Create a better_grade_than? method, that you can call like so...

# puts "Well done!" if joe.better_grade_than?(bob)

class Student
  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    @grade > other_student.grade
  end

  protected

  def grade
    @grade
  end

end

joe = Student.new("Joe", 98)
bob = Student.new("Bob", 75)
puts "Well done!" if joe.better_grade_than?(bob)





