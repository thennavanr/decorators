Decorators
----------

Comparing and contrasting different styles of decorators in Ruby.

I use the terms "Decorator" and "Component" in the [Gang of Four](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612) sense.

Class + Method Missing Decorator
--------------------------------

    rspec spec/class_method_missing_spec.rb

Benefits:

* can be wrapped infinitely using Ruby instantiation
* delegates through all decorators
* can use the same decorator more than once on the same component
* transparently uses component's original interface

Drawbacks:

* uses `method_missing`

How it's used:

    class Coffee
      include Component

      def cost
        2
      end

      def origin
        "Colombia"
      end
    end

    class Milk
      include Decorator

      def cost
        @component.cost + 0.4
      end
    end

    class Sugar
      include Decorator

      def cost
        @component.cost + 0.2
      end
    end

    coffee = Coffee.new
    Sugar.new(Milk.new(coffee)).cost                      # 2.6
    coffee.decorate_with(Milk, Sugar).cost                # 2.6
    coffee.decorate_with(Sugar, Sugar, Sugar, Sugar).cost # 2.8
    coffee.decorate_with(Milk, Sugar).origin              # Columbia

Module + Extend + Super Decorator
---------------------------------

    rspec spec/module_extend_super_spec.rb

Benefits:

* delegates through all decorators
* has the original interface because it is the original object

Drawbacks:

* can not use the same decorator more than once on the same object
* difficult to tell which decorator added the functionality
* requires DSL like `decorate_with`

How it's used:

    class Coffee
      include Component

      def cost
        2
      end

      def origin
        "Colombia"
      end
    end

    module Milk
      def cost
        super + 0.4
      end
    end

    module Sugar
      def cost
        super + 0.2
      end
    end

    coffee = Coffee.new
    coffee.decorate_with(Milk, Sugar).cost # 2.6
    coffee.decorate_with(Sugar).origin     # Columbia

Plain Old Ruby Object Decorator
-------------------------------

    rspec spec/plain_old_ruby_object_spec.rb

Benefits:

* can be wrapped infinitely using Ruby instantiation
* delegates through all decorators
* can use same decorator more than once on component

Drawbacks:

* cannot transparently use component's original interface

How it's used:

    class Coffee
      def cost
        2
      end

      def origin
        "Colombia"
      end
    end

    class Milk
      def initialize(component)
        @component = component
      end

      def cost
        @component.cost + 0.4
      end
    end

    class Sugar
      def initialize(component)
        @component = component
      end

      def cost
        @component.cost + 0.2
      end
    end

    coffee = Coffee.new
    Sugar.new(Milk.new(coffee)).cost  # 2.6
    Sugar.new(Sugar.new(coffee)).cost # 2.4
    Milk.new(coffee).origin           # NoMethodError

SimpleDelegator + Super + Getobj Decorator
---------------------------------

    rspec spec/simple_delegator_super_getobj_spec.rb

Benefits:

* can be wrapped infinitely using Ruby instantiation
* delegates through all decorators
* can use same decorator more than once on component
* transparently uses component's original interface
* class is the component

Drawbacks:

* redefines `class`

How it's used:

    require 'delegate'

    class Coffee
      def cost
        2
      end

      def origin
        "Colombia"
      end
    end

    class Decorator < SimpleDelegator
      def class
        __getobj__.class
      end
    end

    class Milk < Decorator
      def cost
        super + 0.4
      end
    end

    class Sugar < Decorator
      def cost
        super + 0.2
      end
    end

    coffee = Coffee.new
    Sugar.new(Milk.new(coffee)).cost   # 2.6
    Sugar.new(Sugar.new(coffee)).cost  # 2.4
    Milk.new(coffee).origin            # Colombia
    Sugar.new(Milk.new(coffee)).class  # Coffee

