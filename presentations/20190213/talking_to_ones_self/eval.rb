#! /usr/bin/env ruby

class MyClass
  def my_method(some_object)
    some_object.instance_eval do
      puts "self = #{inspect}, object_id = #{object_id}"
    end
  end
end

first_instance = MyClass.new
second_instance = MyClass.new

puts "first_instance = #{first_instance.inspect}"
puts "second_instance = #{second_instance.inspect}"

first_instance.my_method(second_instance)
