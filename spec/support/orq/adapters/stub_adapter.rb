class StubAdapter
  def initialize(config = {})
    @@instance = self
  end
  
  def self.instance
    @@instance
  end
end