# 1)Given the below usage of the Person class, code the class definition.

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{@first_name} #{@last_name} "
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ""
  end

end

# bob = Person.new('bob')
# puts bob.name                  # => 'bob'
# bob.name = 'Robert'
# puts bob.name                  # => 'Robert'

# 2) Modify the class definition from above to facilitate the following methods. 
# Note that there is no name= setter method now.

bob = Person.new('Robert')
puts bob.name                  # => 'Robert'
puts bob.first_name            # => 'Robert'
puts bob.last_name             # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'
bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')
puts rob.name == bob.name
puts "The person's name is: #{bob}"







