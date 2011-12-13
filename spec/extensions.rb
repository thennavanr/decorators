class String
  def /(path)
    File.join(self, path)
  end
end

class Dir
  def self.here
    File.dirname(caller[0].split(':').first)
  end

  def self.up
    here / '..'
  end
end
