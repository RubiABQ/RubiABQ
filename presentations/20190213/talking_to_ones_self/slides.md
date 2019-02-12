---
title: Talking to One's Self
pdf: talking-to-ones-self.pdf
slideNumber: true
controls: true
---

# Talking to One's Self
## Receivers: visibility, scope and metaprogramming

<small>
a [markdeck](https://arnehilmann.github.io/markdeck/){target="_blank"} experiment

```render_a2s
#----------.
|[markdeck]|
'----------#
[markdeck]: {"fill": "Teal", "fillStyle": "solid"}
```
</small>

# Overview
* You can write Ruby w/o knowing much about `self`
* Learning about `self` helps explain metaprogramming
* Downside: the buzz of a fluorescent light

# Markdeck Recap
* Last month we discussed Markdown
* Hacker News mentioned Markdeck
* Today's talk is an experiment

# `self`?

* Much of Ruby is sending messages to _receivers_
* The context-dependent _implicit_ receiver is used when there's no _explicit_ receiver
* Ruby uses the identifier `self` to name the implicit receiver

# Hello World
```ruby
#! /usr/bin/env ruby

puts "Hello World!"
```

```
bash-3.2[talking_to_oneself]$ ./hello_world.rb 
Hello World!
```

# Hello Explicit Receiver

```
#! /usr/bin/env ruby

STDOUT.puts "Hello Explicit Receiver!"
```

```
bash-3.2[talking_to_oneself]$ ./hello_explicit_receiver.rb 
Hello Explicit Receiver!
```

# Hello `self`

```
#! /usr/bin/env ruby

puts "Hello self = #{self.inspect}"
```

```
bash-3.2[talking_to_oneself]$ ./hello_self.rb 
Hello self = main
```

# Hello `main`

```
#! /usr/bin/env ruby

main.puts "Hello main"
```

```
bash-3.2[talking_to_oneself]$ ./hello_main.rb 
./hello_main.rb:3:in `<main>': undefined local variable or method `main' for main:Object (NameError)
```

# Hello `main` Take Two

```
#! /usr/bin/env ruby

main = self
main.puts "Hello main"
```

```
bash-3.2[talking_to_oneself]$ ./hello_main_revisited.rb 
./hello_main_revisited.rb:4:in `<main>': private method `puts' called for main:Object (NoMethodError)
```

# We're getting somewhere

```
#! /usr/bin/env ruby

main = self
main.send :puts, "Hello main"

puts "BTW: main.object_id = #{main.object_id}"
puts "and self.object_id = #{self.object_id}"
puts "and, the mind blower, object_id = #{object_id}"
```

```
bash-3.2[talking_to_oneself]$ ./hello_send_main.rb
Hello main
BTW: main.object_id = 70207033242360
and self.object_id = 70207033242360
and, the mind blower, object_id = 70207033242360
```

# Pop Quiz

* `main.puts` failed, because `puts` was private.  Why didn't `STDOUT.puts` fail?
* If we had written `self.puts` instead of `main.puts`, would that have worked?
* When can `self.` as a prefix allow a private method to be called?

# Answers

* They're two different methods, main's comes from the Kernel module, STDOUT's comes from IO
* No. When you type "self." you now have an explicit receiver and by definition you can't use a private method with an explicit receiver, except...
* ...when the private method is a setter


# Buzzzzzzzzzz

```
bash-3.2[talking_to_oneself]$ rubocop hello_send_main.rb
Inspecting 1 file
C

Offenses:

hello_send_main.rb:7:30: C: Style/RedundantSelf: Redundant self detected.
puts "and self.object_id = #{self.object_id}"
                             ^^^^^^^^^^^^^^

1 file inspected, 1 offense detected
```

# When is "`self.`" needed?

# Setters, Ours

```
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
```

```
bash-3.2[talking_to_oneself]$ ./common_mistake.rb
broken: setting = 42
after broken, foo.setting = nil
fixed: setting = 42
after fixed, foo.setting = 42
```

# Setters, Ruby's

```ruby
#! /usr/bin/env ruby

class MyClass
  attr_writer :property
  attr_reader :property

  def same_problem
    property = 42
  end

  def same_solution
    self.property = 42
  end
end

foo = MyClass.new
foo.same_problem
puts "foo.property = #{foo.property.inspect}"
foo.same_solution
puts "foo.property = #{foo.property.inspect}"
```

```
bash-3.2[talking_to_oneself]$ ./setters_dont_change_things.rb 
foo.property = nil
foo.property = 42
```

# Defining Class Methods

We'll come back to this one later.

# Invoking Methods with Funky Names

* keyword method names
* capitalized method names

# `class` is a keyword and method name

```ruby
#! /usr/bin/env ruby

puts class.name
```

```
bash-3.2[talking_to_oneself]$ ./class_name.rb 
./class_name.rb:3: syntax error, unexpected '.'
puts class.name
```

```ruby
#! /usr/bin/env ruby

puts self.class.name
```

```
bash-3.2[talking_to_oneself]$ ./fixed_class_name.rb 
Object
```

# Capitalized Method Names

```ruby
#! /usr/bin/env ruby

class MyClass
  def DontDoThis
    puts "Don't do this."
  end

  def call_that_bad_method
    DontDoThis
  end
end

MyClass.new.call_that_bad_method
```

```
bash-3.2[talking_to_oneself]$ ./broken_bad_method_name.rb 
Traceback (most recent call last):
	1: from ./broken_bad_method_name.rb:13:in `<main>'
./broken_bad_method_name.rb:9:in `call_that_bad_method': uninitialized constant MyClass::DontDoThis (NameError)
```

# Capitalized Method Names continued

```ruby
#! /usr/bin/env ruby

class MyClass
  def DontDoThis
    puts "Don't do this."
  end

  def call_that_bad_method
    self.DontDoThis
  end
end

MyClass.new.call_that_bad_method
```

```
bash-3.2[talking_to_oneself]$ ./fixed_bad_method_name.rb 
Don't do this.
```

# Method Shadowed by Variable

```ruby
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
```

```
bash-3.2[talking_to_oneself]$ ./hidden.rb 
In it_wont_call
In it_will_call
Hello from some_identifer
```

# Identifier: value or method invocation?
* It's *not* the presence of the method
* It's the presence (or absence) of the variable
* Local variables are created by `=`
* Variables are lexically scoped (top to bottom, left to right)
* Short methods (and rubocop!) help

# Lexical Scope: Top to Bottom
```ruby
#! /usr/bin/env ruby

puts "At top, defined?(foo) = #{defined?(foo).inspect}"
puts "So ... we're not even going to look at foo"
if false
  foo = 42
end
puts "After if, defined?(foo) = #{defined?(foo).inspect}"
puts "foo itself = #{foo.inspect}"
```

```
bash-3.2[talking_to_oneself]$ ./top_to_bottom.rb 
At top, defined?(foo) = nil
So ... we're not even going to look at foo
After if, defined?(foo) = "local-variable"
foo itself = nil
```

# Lexical Scope: Left to Right

```ruby
#! /usr/bin/env ruby

foo = 3 if defined?(foo)
puts "After if, defined?(foo) = #{defined?(foo).inspect}"
puts "foo itself = #{foo.inspect}"

puts "Hey! what about me?" if defined?(bar)
puts "After if, defined?(bar) = #{defined?(bar).inspect}"
```

```
bash-3.2[talking_to_oneself]$ ./left_to_right.rb 
After if, defined?(foo) = "local-variable"
foo itself = 3
After if, defined?(bar) = nil
```

# Defining Class Methods

```ruby
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
```

```
bash-3.2[talking_to_oneself]$ ./class_methods.rb 
foo
bar
baz
```

# "`self.`" good use case summary

* `self.attribute = value`
* `self.class`
* `def self.method`


# When does `self` change?

* inside a class or module definition
* inside a method definition
* inside eval

# Class or Module

```ruby
#! /usr/bin/env ruby

class MyClass
  puts "self = #{inspect}, object_id = #{object_id}"
end

module MyModule
  puts "self = #{inspect}, object_id = #{object_id}"
end

# No need for code here
```

```
bash-3.2[talking_to_oneself]$ ./class.rb 
self = MyClass, object_id = 70335424860240
self = MyModule, object_id = 70335424860020
```

# Method

```ruby
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
```

```
bash-3.2[talking_to_oneself]$ ./method.rb 
self = #<MyClass:0x00007f9876a11fd8>, object_id = 70146401013740
self = #<MyClass:0x00007f9876a11fb0>, object_id = 70146401013720
```

# Eval

```ruby
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
```

```
bash-3.2[talking_to_oneself]$ ./eval.rb 
first_instance = #<MyClass:0x00007fc939071bd8>
second_instance = #<MyClass:0x00007fc939071bb0>
self = #<MyClass:0x00007fc939071bb0>, object_id = 70251110960600
```

# `instance_eval` takes a block

```ruby
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
```

```
bash-3.2[talking_to_oneself]$ ./eval_block.rb 
first_instance = #<MyClass:0x00007fbfb7071c18>
second_instance = #<MyClass:0x00007fbfb7071bf0>
self = #<MyClass:0x00007fbfb7071bf0>, object_id = 70230693088760
```

# Meta Programming

* What are `belongs_to` and `has_many` in Rails?
* They would look uglier without an implicit receiver

# Pop Quiz

* What does the code below do?
* What are some places you might use `self` without a following period in your code?

[//]: # (when you want to pass self as an argument to some other method; when you want to use self as a receiver for a method that is invoked by operators, e.g. self[:foo]; there are probably others, but those two come to mind)

```ruby
  def transform_setter(*attributes, &block)
    attributes.each do |attribute|
      define_method("#{attribute}=") do |value|
        super(value&.instance_eval(&block))
      end
    end
  end
```

# Answers

* to pass `self` as an argument to some other method
* to use `self` as a receiver for a method invoked by operators (e.g., `self[:attr]`)
* Those are the two I can think of, there are probably others

# Answers continued

```ruby
#! /usr/bin/env ruby

# FWIW, transform_setter is a real snippet of code that's used in a Rails
# application as a concern, but dragging Rails into this demo would be
# overkill, so we'll just pretend.

module MyModule
  def transform_setter(*attributes, &block)
    attributes.each do |attribute|
      define_method("#{attribute}=") do |value|
        super(value&.instance_eval(&block))
      end
    end
  end
end

# MyClass represents what ActiveRecord does behind the scenes with a
# combination of ApplicationRecord and metaprogramming.  The point here
# is that the setter will be availble via super in the method defined
# by transform_setter.

class ApplicationRecord
  def some_column=(value)
    puts "Pretend I'm setting some_column to #{value.inspect}"
  end
end

class MyModel < ApplicationRecord
  extend MyModule
  
  transform_setter :some_column, &:upcase
end

model = MyModel.new
model.some_column = "some value"
```

```
bash-3.2[talking_to_oneself]$ ./transform_setter.rb 
Pretend I'm setting some_column to "SOME VALUE"
```
