class Bulldog
  def swim
    "can't swim!"
  end
end

class Person
  attr_accessor :name, :pet

  def initialize(name)
    @name = name
  end
end

bob = Person.new("Robert")
bud = Bulldog.new             # assume Bulldog class from previous assignment

puts bob.pet = bud
