#! /usr/bin/env ruby

class MyClass
  def self.foo
    puts "foo"
  end

  def MyClass.bar
    puts "bar"
  end

  class << self
    def baz
      puts "baz"
    end
  end
end

MyClass.foo
MyClass.bar
MyClass.baz
