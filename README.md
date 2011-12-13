Decorators
----------

An experiment with different styles of decorators in Ruby.

Class Decorator
---------------

    rspec spec/class_decorator_spec.rb

Benefits:

* delegates through all decorators
* can be chained infinitely
* can use the same decorator more than once on the same component
* transparently uses component's original interface

Drawbacks:

* type is of the final decorator
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

Module Decorator
----------------

    rspec spec/module_decorator_spec.rb

Benefits:

* delegates through all decorators
* type is of the component
* has the original interface because it is the original object

Drawbacks:

* can not use the same decorator more than once on the same object
* difficult to tell which decorator added the functionality

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

