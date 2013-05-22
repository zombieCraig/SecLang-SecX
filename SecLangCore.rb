require "./SecVar"

class SecLangCore
  attr_accessor :var

  def initialize
    @var = {}
  end

  def add_var(name, var)
    @var[name] = var
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
    @var[name].type.to_s
  end

  def var_dec(name, amt=1)
    name = name.gsub(/\-\-$/, "")
    if @var.has_key? name then
      @var[name].dec(amt.to_i)
    else
      raise ParseError, "#{name} not assigned"
    end
    @var[name].value
  end

  def add_digits(amt1, amt2)
    IntVar.new(amt1.to_i + amt2.to_i)
  end

  def var_add(name, amt)
    if not @var.has_key? name then
      raise ParseError, "#{name} not assigned"
    end
    amt = amt.to_i
    var = @var[name]
    case var.type
      when :integer
        v = IntVar.new(var.add(amt))
      when :hex
        v = HexVar.new(var.value)
        v.inc(amt)
      when :string
        v = StringVar.new(var.value)
        v.inc(amt)
      when :ipv4
        v = IPv4Var.new(var.value).inc(amt)
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_add_var(name, src_name)
    if not @var.has_key? name then
      raise ParseError, "#{name} not assigned"
    end
    if not @var.has_key? src_name then
      raise ParseError, "#{src_name} not assigned"
    end
    src = @var[src_name]
    amt = src.to_i
    self.var_add(name, amt)
  end

  def var_sub(name, amt)
    if not @var.has_key? name then
      raise ParseError, "#{name} not assigned"
    end
    var = @var[name]
    case var.type
      when :integer
        v = IntVar.new(var.sub(amt))
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
    @var[name].value
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
    val1 = val2
  end


end
