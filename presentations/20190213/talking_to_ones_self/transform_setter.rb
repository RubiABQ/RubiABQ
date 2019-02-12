#! /usr/bin/env ruby

# FWIW, transform_setter is a real snippet of code that's used in a Rails
# application as a concern, but dragging Rails into this demo would be
# overkill, so we'll just pretend.

module MyModule
  def transform_setter(*attributes, &block)
    attributes.each do |attribute|
      define_method("#{attribute}=") do |value|
        super(value&.instance_eval(&block))
      end
    end
  end
end

# MyClass represents what ActiveRecord does behind the scenes with a
# combination of ApplicationRecord and metaprogramming.  The point here
# is that the setter will be availble via super in the method defined
# by transform_setter.

class ApplicationRecord
  def some_column=(value)
    puts "Pretend I'm setting some_column to #{value.inspect}"
  end
end

class MyModel < ApplicationRecord
  extend MyModule
  
  transform_setter :some_column, &:upcase
end

model = MyModel.new
model.some_column = "some value"
