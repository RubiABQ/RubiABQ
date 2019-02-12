#! /usr/bin/env ruby

puts "At top, defined?(foo) = #{defined?(foo).inspect}"
puts "So ... we're not even going to look at foo"
if false
  foo = 42
end
puts "After if, defined?(foo) = #{defined?(foo).inspect}"
puts "foo itself = #{foo.inspect}"
