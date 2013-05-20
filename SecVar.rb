class SecVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    @value = val
    @type = :generic
  end

  def to_s
    @value.to_s
  end
end

class IntVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    @value = val
    @type = :integer
  end
end

class StringVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    @value = val
    @type = :string
  end
end

