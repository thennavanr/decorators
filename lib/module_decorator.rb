module Component
  def decorate_with(*decorators)
    decorators.each do |decorator|
      self.extend(decorator)
    end
    self
  end
end
