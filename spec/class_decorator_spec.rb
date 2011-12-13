require 'extensions'
require Dir.up / "lib" / "class_decorator"

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

describe Component do
  let(:coffee) { Coffee.new }

  it "delegates through all decorators" do
    coffee.decorate_with(Milk, Sugar).cost.should == 2.6
  end

  it "type is of the final decorator" do
    coffee.decorate_with(Milk, Sugar).should be_kind_of(Sugar)
  end

  it "can use the same decorator more than once on the component" do
    coffee.decorate_with(Sugar, Sugar, Sugar, Sugar).cost.round(2).should == 2.8
  end
end

describe Decorator do
  it "can be chained infinitely" do
    Sugar.new(Milk.new(Coffee.new)).cost.should == 2.6
  end

  it "transparently uses component's original interface" do
    Milk.new(Coffee.new).origin.should == "Colombia"
  end
end
