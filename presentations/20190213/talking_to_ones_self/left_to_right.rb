#! /usr/bin/env ruby

foo = 3 if defined?(foo)
puts "After if, defined?(foo) = #{defined?(foo).inspect}"
puts "foo itself = #{foo.inspect}"

puts "Hey! what about me?" if defined?(bar)
puts "After if, defined?(bar) = #{defined?(bar).inspect}"
