#! /usr/bin/env ruby

class MyClass
  puts "self = #{inspect}, object_id = #{object_id}"
end

module MyModule
  puts "self = #{inspect}, object_id = #{object_id}"
end

# No need for code here
