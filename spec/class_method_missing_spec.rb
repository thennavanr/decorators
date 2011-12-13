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

describe "Benefits" do
  it "can be wrapped infinitely using Ruby instantiation" do
    Sugar.new(Milk.new(Coffee.new)).cost.should == 2.6
  end

  it "delegates through all decorators" do
    Coffee.new.decorate_with(Milk, Sugar).cost.should == 2.6
  end

  it "transparently uses component's original interface" do
    Coffee.new.decorate_with(Milk, Sugar).origin.should == "Colombia"
  end

  it "can use same decorator more than once on component" do
    Coffee.new.decorate_with(Sugar, Sugar, Sugar, Sugar).cost.round(2).should == 2.8
  end
end

describe "Drawbacks" do
  it "type is of the final decorator" do
    Coffee.new.decorate_with(Milk, Sugar).should be_kind_of(Sugar)
  end
end
