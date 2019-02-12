#! /usr/bin/env ruby

class MyClass
  def some_identifier
    puts "Hello from some_identifer"
  end

  def it_wont_call
    puts "In it_wont_call"
    some_identifier = "now we have a local variable"
    some_identifier
  end

  def it_will_call
    puts "In it_will_call"
    some_identifier = "now we *still* have a local variable"
    self.some_identifier
  end
end

foo = MyClass.new
foo.it_wont_call
foo.it_will_call
