require "./SecVar"

class SecLangCore
  attr_accessor :var

  def initialize
    @var = {}
  end

  # Adds a variable to the stack
  def add_var(name, var)
    @var[name] = var
  end

  def get_var(name)
    if not @var.has_key? name
      raise ParseError, "#{name} variable not defined"
    end
    @var[name]
  end

  def copy_var(dst_name, src_name)
    if not @var.has_key? src_name
      raise ParseError, "#{src_name} not defined"
    else
      @var[dst_name] = @var[src_name].dup
    end
  end

  def var_value(name)
    if @var.has_key? name
      @var[name].value
    else
     raise ParseError, "#{name} not assigned"
    end
  end

  def var_type(name)
    raise ParseError, "#{name} not assigned" if not @var.has_key? name
    StringVar.new(@var[name].type.to_s)
  end

  def var_dec(name, amt=1)
    name = name.gsub(/\-\-$/, "")
    if @var.has_key? name then
      @var[name].dec(amt.to_i)
    else
      raise ParseError, "#{name} not assigned"
    end
    @var[name]
  end

  def var_add(var, amt)
    amt = amt.to_i
    v = SecVar.new(0)
    case var.type
      when :integer
        v = IntVar.new(var.add(amt))
      when :hex
        v = HexVar.new(var.value.dup)
        v.inc(amt)
      when :string
        v = StringVar.new(var.value.dup)
        v.inc(amt)
      when :ipv4
        v = IPv4Var.new(var.value.dup)
        v.inc(amt)
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_add_var(name, src)
    raise ParseError, "Improper math reference" if not src
    amt = src.to_i
    self.var_add(name, amt)
  end

  def var_sub_var(name, src)
    raise ParseError, "Improper math reference" if not src
    amt = src.to_i
    self.var_sub(name, amt)
  end

  def var_sub(var, amt)
    amt = amt.to_i
    case var.type
      when :integer
        v = IntVar.new(var.dec(amt))
      when :hex
        v = HexVar.new(var.value.dup)
        v.dec(amt)
      when :string
        v = StringVar.new(var.value.dup)
        v.dec(amt)
      when :ipv4
        v = IPv4Var.new(var.value.dup)
        v.dec(amt)
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_inc(name, amt=1)
    name = name.gsub(/\+\+$/, "")
    if @var.has_key? name then
      @var[name].inc(amt.to_i)
    else
      raise ParseError, "#{name} not assigned"
    end
    @var[name]
  end

  def var_inc_var(dst_name, src_name)
    if not @var.has_key? src_name then
      raise ParseError, "#{src_name} not defined"
    end
    if var_type(src_name) != "integer" then
      raise ParseError, "Can not add #{src_name} of type #{var_type(src_name)}"
    end
    var_inc(dst_name, var_value(src_name))
  end

  def var_dec_var(dst_name, src_name)
    if not @var.has_key? src_name then
      raise ParseError, "#{src_name} not defined"
    end
    if var_type(src_name) != "integer" then
      raise ParseError, "Can not add #{src_name} of type #{var_type(src_name)}"
    end
    var_dec(dst_name, var_value(src_name))
  end

  def var_get_mode(name)
    if not @var.has_key? name then
      raise ParseError, "#{name} not assigned"
    end
    @var[name].mode
  end

  def var_set_mode(name, mode)
    if @var.has_key? name then
      @var[name].set_mode mode
    else
      raise ParseError, "#{name} not assigned"
    end
    @var[name].mode
  end

  def is_eq?(val1, val2)
    val1.value == val2.value
  end

  def int(val)
    IntVar.new(val.to_i)
  end

  def hex(val)
    if val.is_a? IntVar
      HexVar.new(val.to_s(16))
    elsif val.is_a? HexVar
      val
    else
      HexVar.new(val.value)
    end
  end

  def sec_puts(var)
    if var.is_a? TrueClass then
      puts var
    elsif var.type == :string then
      s = var.to_s.dup
      s.gsub!("\\n", "\n")
      puts s
    else
      puts var
    end
  end

  def sec_print(var)
    if var.is_a? TrueClass then
      print var
    elsif var.type == :string then
      s = var.to_s.dup
      s.gsub!("\\n", "\n")
      print s
    else
      print var
    end
  end

  def shell(cmd)
    StringVar.new(`#{cmd}`)
  end

end
