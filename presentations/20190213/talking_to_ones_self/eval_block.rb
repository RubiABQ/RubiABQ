#! /usr/bin/env ruby

class MyClass
  def my_method(some_object, &block)
    some_object.instance_eval(&block)
  end
end

first_instance = MyClass.new
second_instance = MyClass.new

puts "first_instance = #{first_instance.inspect}"
puts "second_instance = #{second_instance.inspect}"

first_instance.my_method(second_instance) do
  puts "self = #{inspect}, object_id = #{object_id}"
end
