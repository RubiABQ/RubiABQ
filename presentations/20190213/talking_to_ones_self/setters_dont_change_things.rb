#! /usr/bin/env ruby

class MyClass
  attr_writer :property
  attr_reader :property

  def same_problem
    property = 42
  end

  def same_solution
    self.property = 42
  end
end

foo = MyClass.new
foo.same_problem
puts "foo.property = #{foo.property.inspect}"
foo.same_solution
puts "foo.property = #{foo.property.inspect}"
