#! /usr/bin/env ruby

class MyClass
  def setting=(value)
    @setting = value
  end

  def setting
    @setting
  end

  def broken_set_setting_to_42
    setting = 42
    puts "broken: setting = #{setting.inspect}"
  end

  def fixed_set_setting_to_42
    self.setting = 42
    puts "fixed: setting = #{setting.inspect}"
  end
end    

foo = MyClass.new

foo.broken_set_setting_to_42
puts "after broken, foo.setting = #{foo.setting.inspect}"

foo.fixed_set_setting_to_42
puts "after fixed, foo.setting = #{foo.setting.inspect}"

