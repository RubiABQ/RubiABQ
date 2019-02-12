#! /usr/bin/env ruby

class MyClass
  def my_method
    puts "self = #{inspect}, object_id = #{object_id}"
  end
end

first_instance = MyClass.new
second_instance = MyClass.new
first_instance.my_method
second_instance.my_method
