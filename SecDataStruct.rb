# Series of SecLang data structures

class ArrayVar < SecVar
   attr_reader :values

  def initialize(val = nil)
    @type = :array
    if val and val.is_a? Array then
      @values = val
    elsif val.is_a? ArrayVar then
      @values = val.values.dup
    elsif val == nil
      @values = Array.new
    else
      puts "WARNING: Array initialized by unknown val type: #{val.class}"
      @values = Array.new
    end
  end

  def value
    ArrayVar.new(@values)
  end

  def concat(arr)
    arr = arr.values if arr.is_a? ArrayVar
    if arr.is_a? Array then
      @values.concat arr
    else
      raise RuntimeError, "Can only concat Arrays (#{arr.class})"
    end
  end

  def slice(index)
    index = index.to_i.value
    @values[index]
  end

  def push val
    @values << val
    ArrayVar.new(@values)
  end

  def << val
    self.push val
  end

  def pop
    @values.pop
  end

  def length
    IntVar.new(@values.size)
  end

  def size
    self.length
  end

  def to_s
    s = "["
    cnt = 0
    @values.each do |val|
      s = "#{s} #{val.to_s}"
      cnt += 1
      s = "#{s}," if not cnt == @values.length
    end
    s = "#{s} ]"
    s
  end

  def auto_color
    s = StringVar.new("[").bold
    cnt = 0
    @values.each do |val|
      s += val.auto_color
      cnt += 1
      s += StringVar.new(",").bold if not cnt == @values.length
    end
    s += StringVar.new(" ]").bold
    s
  end

end
