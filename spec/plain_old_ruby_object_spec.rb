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

describe "Benefits" do
  it "delegates through all decorators" do
    Sugar.new(Milk.new(Coffee.new)).cost.round(2).should == 2.6
  end

  it "can use same decorator more than once on component" do
    Sugar.new(Sugar.new(Coffee.new)).cost.round(2).should == 2.4
  end
end

describe "Drawbacks" do
  it "cannot transparently use component's original interface" do
    expect { Milk.new(Coffee.new).origin }.to raise_error(NoMethodError)
  end
end
