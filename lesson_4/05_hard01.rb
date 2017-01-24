# Alyssa has been assigned a task of modifying a class that was
# initially created to keep track of secret information. The new
# requirement calls for adding logging, when clients of the class
# attempt to access the secret data. Here is the class in its current
# form:

class SecretFile
  attr_reader :data

  def initialize(secret_data)
    @data = secret_data
  end
end

# She needs to modify it so that any access to data must result in
# a log entry being generated. That is, any call to the class which
# will result in data being returned must first call a logging class.
# The logging class has been supplied to Alyssa and looks like the
# following:

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end

class SecretFile1
  def initialize(secret_data, logger)
    @data = secret_data
    logger = logger
  end

  def data
    logger.create_log_entry
    @data
  end
end


# Ben and Alyssa are working on a vehicle management system.
# So far, they have created classes called Auto and Motorcycle to
# represent automobiles and motorcycles. After having noticed common
# information and calculations they were performing for each type of
# vehicle, they decided to break out the commonality into a separate
# class called WheeledVehicle. This is what their code looks like so
# far:

module Moveable
  attr_accessor :speed, :heading
  attr_reader :fuel_capacity, :fuel_efficiency

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

# Now Alan has asked them to incorporate a new type of vehicle into their system
# - a Catamaran defined as follows:

class Seacraft
  include Moveable

  attr_accessor :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    self.num_propellers = num_propellers
    self.num_hulls = num_hulls
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def range
    range_by_using_fuel = super
    return range_by_using_fuel + 10
  end
end

class Motorboat < Seacraft
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

class Catamaran < SeaCraft
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

# This new class does not fit well with the object hierarchy defined so far.
# Catamarans don't have tires. But we still want common code to track fuel 
# efficiency and range. Modify the class definitions and move code into a 
# Module, as necessary, to share code among the Catamaran and the wheeled vehicles.

# Building on the prior vehicles question, we now must also track a basic 
# motorboat. A motorboat has a single propeller and hull, but otherwise behaves 
# similar to a catamaran. Therefore, creators of Motorboat instances don't need 
# to specify number of hulls or propellers. How would you modify the vehicles 
# code to incorporate a new Motorboat class?

# The designers of the vehicle management system now want to make an adjustment 
# for how the range of vehicles is calculated. For the seaborne vehicles, due to 
# prevailing ocean currents, they want to add an additional 10km of range even 
# if the vehicle is out of fuel.
# Alter the code related to vehicles so that the range for autos and motorcycles 
# is still calculated as before, but for catamarans and motorboats, the range 
# method will return an additional 10km.





