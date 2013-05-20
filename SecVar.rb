class SecVar
  attr_accessor :value
  attr_reader :type, :mode

  def initialize(val)
    @value = val
    @type = :generic
    @mode = "N/A"
  end

  def to_s
    @value.to_s
  end

  def inc
  end

end

class IntVar < SecVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    @value = val.to_i
    @type = :integer
  end

  def inc
    @value += 1
  end

  def set_mode
    puts "WARNING: mode is unsupported on type #{type} vars"
  end
end

class StringVar < SecVar
  attr_accessor :value
  attr_reader :type, :mode

  def initialize(val)
    @value = val
    @type = :string
    @mode  = :mixed_case

    @lower = "abcdefghijklmnopqrstuvwxyz"
    @upper = @lower.upcase
    @mixed = @lower + @upper
    @alphanum = @mixed + "1234567890"
  end

  def inc(pos = -1)
    charset = ""
    case @mode
    when :mixed_case
      charset = @mixed
    when :upper
      charset = @upper
    when :lower
      charset = @lower
    when :alphanum
      charset = @alphanum
    else
      charset = @mixed
    end

    last_char = @value[pos]
    idx = charset.index(last_char)
    if idx >= charset.length-1 then
      @value[pos] = charset[0]
      pos -= 1
      if pos.abs > @value.length then
        @value = "#{charset[0]}#{@value}"
      else
        self.inc(pos)
      end
    else
      @value[pos] = charset[idx + 1]
    end
  end

  def set_mode(mode)
    case mode
      when ":mixed"
        @mode = :mixed
      when ":lower"
        @mode = :lower
      when ":upper"
        @mode = :upper
      when ":alphanum"
        @mode = :alphanum
      else
        puts "ERROR: unknown mode type #{mode} for #{@type} var"
    end
  end
end

class IPv4Var < SecVar
  attr_accessor :value
  attr_reader :type, :mode

  def initialize(val)
    @value = val
    @type = :ipv4
    @mode = "N/A"
  end

  def inc(pos = 3)
    oct = @value.split(".")
    if pos < 0 then
      @value = "0.0.0.0"
      return @value
    end
    if oct[pos].to_i == 255 then
      oct[pos] = 0
      pos -= 1
      @value = oct.join(".")
      self.inc(pos)
    else
      oct[pos] = oct[pos].to_i + 1
      @value = oct.join(".")
    end
    @value
  end
end
