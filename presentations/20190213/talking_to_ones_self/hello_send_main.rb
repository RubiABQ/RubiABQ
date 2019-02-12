#! /usr/bin/env ruby

main = self
main.send :puts, "Hello main"

puts "BTW: main.object_id = #{main.object_id}"
puts "and self.object_id = #{self.object_id}"
puts "and, the mind blower, object_id = #{object_id}"
