module Component
  def decorate_with(*decorators)
    decorators.inject(self) do |object, decorator|
      decorator.new(object)
    end
  end
end

module Decorator
  def initialize(component)
    @component = component
  end

  def method_missing(method, *args)
    if args.empty?
      @component.send(method)
    else
      @component.send(method, args)
    end
  end
end
