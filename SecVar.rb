#!/bin/env ruby
# encoding: utf-8

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

  def to_i
  end

  def to_f
  end

  def add(amt)
  end

  def sub(amt)
  end

  def mult(amt)
  end

  def div(amt)
  end

  def inc(amt=0,pos=0)
  end

  def dec(amt=0,pos=0)
  end

  # Returns -1 if <, 0 if ==, 1 if >
  def compare(val)
    return -1 if @value < val.value 
    return 1 if @value > val.value 
    0
  end

end

class IntVar < SecVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    if val.is_a? Fixnum then
      @value = val
    elsif val.is_a? IntVar then
      @value = val.value
    else
      @value = val.to_i
    end
    @type = :integer
  end

  def >(obj)
    if obj.is_a? FloatVar then
      return @value > obj.value
    else
      return @value > obj.to_i
    end
  end

  def <(obj)
    if obj.is_a? FloatVar then
      return @value < obj.value
    else
      return @value < obj.to_i
    end
  end


  def +(amt)
    amt = amt.value if amt.is_a? IntVar
    self.add amt
  end

  def -(amt)
    amt = amt.value if amt.is_a? IntVar
    self.sub amt
  end

  def add(amt)
    amt = amt.value if amt.is_a? IntVar
    @value + amt.to_i
  end

  def sub(amt)
    amt = amt.value if amt.is_a? IntVar
    @value - amt.to_i
  end

  def mult(amt)
    amt = amt.value if amt.is_a? IntVar
    if amt.is_a? FloatVar then
      return FloatVar.new(@value * amt.value)
    end
    IntVar.new(@value * amt.to_i)
  end

  def div(amt)
    if amt.is_a? IntVar or amt.is_a? FloatVar
      amt = amt.value
    else
      amt = amt.to_i
    end
    FloatVar.new(@value.to_f / amt.to_f)
  end

  def inc(amt = 1, pos=0)
    amt = amt.value if amt.is_a? IntVar
    @value += amt
  end

  def dec(amt = 1, pos=0)
    amt = amt.value if amt.is_a? IntVar
    @value -= amt
  end

  # Need for range
  def succ
    IntVar.new(@value + 1)
  end

  def <=>(other)
    @value <=> other.value 
  end

  def to_i
    return IntVar.new(@value) if not @value.is_a? IntVar
    @value
  end

  def to_f
    @value.to_f
  end

  def set_mode
    puts "WARNING: mode is unsupported on type #{type} vars"
  end
end

class FloatVar < SecVar
  attr_accessor :value
  attr_reader :type

  def initialize(val)
    @value = val.to_f
    @type = :float
  end

  def +(amt)
    self.add amt
  end

  def -(amt)
    self.sub amt
  end

  def add(amt)
    @value + amt.to_f
  end

  def sub(amt)
    @value - amt.to_f
  end

  def mult(amt)
    if amt.is_a? FloatVar then
      return FloatVar.new(@value * amt.value)
    end
    FloatVar.new(@value * amt.to_i.value)
  end

  def div(amt)
    if amt.is_a? IntVar or amt.is_a? FloatVar
      amt = amt.value
    else
      amt = amt.to_i
    end
    FloatVar.new(@value.to_f / amt.to_f)
  end


  def inc(amt = 1, pos=0)
    @value += amt
  end

  def dec(amt = 1, pos=0)
    @value -= amt
  end

  # Need for range
  def succ
    FloatVar.new(@value + 1)
  end

  def <=>(other)
    @value <=> other.value 
  end

  def to_i
    @value.to_i
  end

  def to_f
    @value
  end

  def set_mode
    puts "WARNING: mode is unsupported on type #{type} vars"
  end

end

class StringVar < SecVar
  attr_reader :type, :mode, :inject_char

  def initialize(val="")
    raise "Error: bad val#{val} (#{val.class}) for String" if not val.is_a? String
    @value = val
    @type = :string
    @mode  = :mixed_case
    @inject_char = "§"

    @lower = "abcdefghijklmnopqrstuvwxyz"
    @digits = "0123456789"
    @upper = @lower.upcase
    @mixed = @lower + @upper
    @alphanum = @mixed + @digits
    @hex = @digits + "abcdef"

    auto_setmode
  end

  def value=(val)
    @value = val
    auto_setmode
  end

  def value
    @value
  end

  def to_i
    IntVar.new(@value.to_i)
  end

  def to_hex
    if @value=~/^0x/ then
      HexVar.new(@value)
    else 
      HexVar.new("0x#{@value.unpack('H*')[0]}")
    end
  end

  def length
    IntVar.new(@value.length)
  end

  def slice(index)
    index = index.to_i
    StringVar.new(@value[index])
  end

  def succ
    s = StringVar.new(@value.dup)
    s.inc
    s
  end

  def <=>(other)
    return 0 if @value == other.value
    return -1 if @value.size < other.value.size
    return 1 if @value.size > other.value.size
    idx = 0
    (idx..@value.size).each do |x|
      pos = @charset.index(@value[x])
      other_pos = @charset.index(@value[x])
      return -1 if pos < other_pos
      return 1 if pos > other_post
    end
    0
  end

  def mult(amt)
    i = amt.to_i.value
    v = StringVar.new
    if i > 0 then
      (1..i).each do
        v = v.cat @value
      end
    end
    v
  end

  def inc(amt=1,pos=-1)
    last_char = @value[pos]
    idx = @charset.index(last_char)
    raise RuntimeError, "#{last_char} not available for mode #{@mode}" if not idx
    if idx+amt >= @charset.length then
      idx += amt
      div = (idx / @charset.length).floor
      idx -= (@charset.length * div)
      @value[pos] = @charset[idx]
      pos -= 1
      if pos.abs > @value.length then
        @value = "#{@charset[idx+amt - @charset.length]}#{@value}"
      else
        amt = (amt / @charset.length).floor
        amt = 1 if amt == 0
        self.inc(amt, pos)
      end
    else
      @value[pos] = @charset[idx + amt]
    end
  end

  def dec(amt=1,pos=-1)
    return "" if @value.size == 0
    last_char = @value[pos]
    idx = @charset.index(last_char)
    if idx-amt < 0 then
      idx = amt - idx
      div = (idx / @charset.length).floor
      idx = (@charset.length * div) - idx
      @value[pos] = @charset[idx]
      pos -= 1
      if pos.abs > @value.length then
        @value = @value[1, @value.length-1]
      else
        amt = (amt / @charset.length).floor
        amt = 1 if amt == 0
        self.dec(amt, pos)
      end
    else
      @value[pos] = @charset[idx - amt]
    end
  end

  def +(str)
    self.cat(str)
  end

  def cat(str)
    StringVar.new("#{@value}#{str}")
  end

  def set_mode(mode)
    mode = ":#{mode.to_s}" if mode.is_a? Symbol
    case mode
      when ":mixed_case"
        @mode = :mixed_case
        @charset = @mixed
      when ":lower"
        @mode = :lower
        @charset = @lower
      when ":upper"
        @mode = :upper
        @charset = @upper
      when ":alphanum"
        @mode = :alphanum
        @charset = @alphanum
      when ":hex"
        @mode = :hex
        @charset = @hex
      else
        puts "ERROR: unknown mode type #{mode} for #{@type} var"
    end
  end

  private
  # Determins mode based on current @value
  def auto_setmode
    has_digits = @value =~/\d+/ ? true : false
    has_lower = @value=~/[a-z]+/ ? true : false
    has_upper = @value=~/[A-Z]+/ ? true : false
    has_symbols = @value=~/[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]+/ ? true : false
    has_hex = @value=~/^0x[0-9a-fA-F]+$/ ? true : false
    if has_hex then
      self.set_mode(:hex)
    elsif (has_lower or has_upper) and has_digits then
      self.set_mode(:alphanum) 
    elsif has_lower and has_upper and not has_digits then
      self.set_mode(:mixed_case)
    elsif has_lower and not has_upper then
      self.set_mode(:lower)
    elsif has_upper and not has_lower then
      self.set_mode(:upper)
    else
      self.set_mode(:mixed_case)
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

  def inc(amt = 1, pos = 3)
    oct = @value.split(".")
    if pos < 0 then
      @value = "0.0.0.0"
      return @value
    end
    if oct[pos].to_i + amt > 255 then
      oct[pos] = oct[pos].to_i + amt - 255
      pos -= 1
      @value = oct.join(".")
      self.inc((amt / 255) + 1, pos)
    else
      oct[pos] = oct[pos].to_i + amt
      @value = oct.join(".")
    end
    @value
  end

  def dec(amt = 1, pos = 3)
    oct = @value.split(".")
    if pos < 0 then
      @value = "255.255.255.255"
      return @value
    end
    if oct[pos].to_i - amt < 0 then
      oct[pos] = 255 - oct[pos].to_i - amt
      pos -= 1
      @value = oct.join(".")
      self.dec((amt / 255) + 1, pos)
    else
      oct[pos] = oct[pos].to_i - amt
      @value = oct.join(".")
    end
    @value
  end

  def compare(val)
    val_oct = val.to_s.split(".")
    oct = @value.split(".")
    return -1 if val_oct[0] < oct[0]
    return 1 if val_oct[0] > oct[0]
    return -1 if val_oct[1] < oct[1]
    return 1 if val_oct[1] > oct[1]
    return -1 if val_oct[2] < oct[2]
    return 1 if val_oct[2] > oct[2]
    return -1 if val_oct[3] < oct[3]
    return 1 if val_oct[3] > oct[3]
    0
  end

end

class HexVar < StringVar
  attr_reader :type, :mode

  def initialize(val)
    if val.is_a? String
      val = val.gsub(/0x/, "")
      @value = val.downcase
    elsif val.is_a? Fixnum
      @value = val.to_s(16) 
    end
    @type = :hex
    @charset = "0123456789abcdef"
  end

  def to_s
    "0x#{@value}"
  end

  def to_ascii
    [@value].pack("H*")
  end

  def to_i
    IntVar.new(@value.hex.to_i)
  end

  def mult(amt)
    i = to_i
    HexVar.new(i.value * amt.to_i.value)
  end

  def div(amt)
    i = to_i
    HexVar.new((i.value.to_f / amt.to_i.value.to_f).to_i)
  end


  def value=(val)
    val = val.gsub(/0x/, "")
    @value = val.downcase
  end

  def value
    self.to_s
  end

  def set_mode(mode)
    puts "WARNING: mode not supported for Hex Variables"
  end

end
