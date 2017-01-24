# Ben asked Alyssa to code review the following code:

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Alyssa glanced over the code quickly and said - "It looks fine,
# except that you forgot to put the @ before balance when you refer 
# to the balance instance variable in the body of the positive_balance? method."

# "Not so fast", Ben replied. "What I'm doing here is valid - I'm not 
# missing an @!"

# Who is right, Ben or Alyssa, and why?

# I think that Ben is right because you can refer to a getter method
# without using self or @


# Alyssa created the following code to keep track of items for a
# shopping cart application she's writing:

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# Alan looked at the code and spotted a mistake. "This will fail 
# when update_quantity is called", he says.

# Can you spot the mistake and how to address it?

# Here the mistake is that update_quantity calls the quantity instance
# variable, but it's not possible to access this instance variable 
# because there is no setter method for quantity.

# You can address it in two ways:
# - you can simply add @ to quantity in the body of update_quantity
# - you can change the attr_reader with attr_accessor

# Anyway, in this case probably the first solution is preferable,
# because in this way you prevent the user to change the quantity
# without using the update_quantity method.


# Let's practice creating an object hierarchy.

# Create a class called Greeting with a single method called greet 
# that takes a string argument and prints that argument to the 
# terminal.

# Now create two other classes that are derived from Greeting: one
# called Hello and one called Goodbye. The Hello class should have 
# a hi method that takes no arguments and prints "Hello". The Goodbye
# class should have a bye method to say "Goodbye". Make use of the
# Greeting class greet method when implementing the Hello and 
# Goodbye classes - do not use any puts in the Hello or Goodbye 
# classes.

class Greeting
  def greet(string)
    puts string 
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end


# You are given the following class that has been implemented:

class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    if @filling_type == nil && @glazing == nil
      "Plain"
    elsif @glazing == nil
      @filling_type
    elsif @filling_type == nil
      "Plain with #{@glazing}"
    else
      "#{@filling_type} with #{@glazing}"
    end
  end
end

# And the following specification of expected behavior:

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
#  => "Plain"

puts donut2
#  => "Vanilla"

puts donut3
#  => "Plain with sugar"

puts donut4
#  => "Plain with chocolate sprinkles"

puts donut5
#  => "Custard with icing"

# Write additional code for KrispyKreme such that the puts 
# statements will work as specified above.

puts "=" * 50

# If we have these two methods:

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

and

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# What is the difference in the way the code works?

# Both of them works correctly; the main difference is in the body
# of show_template method. Specifically the self in the show_template
# of the Computer class.






