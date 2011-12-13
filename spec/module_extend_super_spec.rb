module Component
  def decorate_with(*decorators)
    decorators.each do |decorator|
      self.extend(decorator)
    end
    self
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

describe "Benefits" do
  it "delegates through all decorators" do
    Coffee.new.decorate_with(Milk, Sugar).cost.should == 2.6
  end

  it "class is the component" do
    Coffee.new.decorate_with(Milk).class.should == Coffee
  end

  it "has the original interface because it is the original object" do
    Coffee.new.decorate_with(Sugar).origin.should == "Colombia"
  end
end

describe "Drawbacks" do
  it "cannot use same decorator more than once on component" do
    Coffee.new.decorate_with(Sugar, Sugar, Sugar, Sugar).cost.round(2).should == 2.2
  end
end
