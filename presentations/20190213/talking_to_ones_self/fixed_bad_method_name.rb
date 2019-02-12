#! /usr/bin/env ruby

class MyClass
  def DontDoThis
    puts "Don't do this."
  end

  def call_that_bad_method
    self.DontDoThis
  end
end

MyClass.new.call_that_bad_method
