require 'extensions'
require Dir.up / "lib" / "module_decorator"

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

describe Component do
  let(:coffee) { Coffee.new }

  it "delegates through all decorators" do
    coffee.decorate_with(Milk, Sugar).cost.should == 2.6
  end

  it "is of a type of the component" do
    coffee.decorate_with(Milk).should be_kind_of(Coffee)
  end

  it "has the original interface because it is the original object" do
    coffee.decorate_with(Sugar).origin.should == "Colombia"
  end
end
