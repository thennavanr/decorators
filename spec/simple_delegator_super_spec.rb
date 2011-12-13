require 'delegate'

class Coffee
  def cost
    2
  end

  def origin
    "Colombia"
  end
end

class Milk < SimpleDelegator
  def cost
    super + 0.4
  end
end

class Sugar < SimpleDelegator
  def cost
    super + 0.2
  end
end

describe "Benefits" do
  it "delegates through all decorators" do
    Sugar.new(Milk.new(Coffee.new)).cost.round(2).should == 2.6
  end

  it "can use same decorator more than once on component" do
    Sugar.new(Sugar.new(Coffee.new)).cost.round(2).should == 2.4
  end

  it "can transparently use component's original interface" do
    Milk.new(Coffee.new).origin.should == "Colombia"
  end
end

describe "Drawbacks" do
  it "type is of the final decorator" do
    Sugar.new(Milk.new(Coffee.new)).should be_kind_of(Sugar)
  end
end
