require "#{File.dirname(__FILE__)}/SecVar"
require "#{File.dirname(__FILE__)}/SecDataStruct"
require "#{File.dirname(__FILE__)}/SecLangFunc"

class SecLangCore
  attr_accessor :var, :color, :parser

  def initialize(parser)
    @parser = parser
    @func = SecLangFunc.new(self)
    @var = {}
    @color = :none
  end

  def color_level
    case @color
    when :none
      return StringVar.new("none")
    when :on
      return StringVar.new("on")
    when :full
      return StringVar.new("full")
    else
      return StringVar.new("unknown state: #{@color}")
    end
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

  def var_mult(var, dst_amt)
    if not dst_amt.type == :float then
      amt = dst_amt.to_i
    else
      amt = dst_amt
    end
    v = SecVar.new(0)
    case var.type
      when :integer
        v = var.mult(amt)
      when :float
        v = var.mult(amt)
      when :hex
        v = var.mult(amt)
      when :string
        v = var.mult(amt)
      when :ipv4
        v = IPv4Var.new(var.value.dup)
        v.mult(amt)
      when :array
        v = ArrayVar.new(var)
        if amt > 0 then
          (0..amt.value).each do
            v.concat var
          end
        end
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_div(var, dst_amt)
    if not dst_amt.type == :float then
      amt = dst_amt.to_i
    else
      amt = dst_amt
    end
    v = SecVar.new(0)
    case var.type
      when :integer
        v = var.div(amt)
      when :float
        v = var.div(amt)
      when :hex
        v = var.div(amt)
      when :string
        v = StringVar.new(var.value.dup)
        v.div(amt)
      when :ipv4
        v = IPv4Var.new(var.value.dup)
        v.div(amt)
      when :array
        v = ArrayVar.new(var)
        if dst_amt > 0 then
          if dst_amt < v.size then
            len = v.size / dst_amt
            v = v[0, len]
          else
            v = ArrayVar.new()
          end
        end
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_add(var, dst_amt)
    dst_amt = IntVar.new(dst_amt) if dst_amt.is_a? Fixnum
    if not dst_amt.type == :float then
      amt = dst_amt.to_i
    else
      amt = dst_amt
    end
    v = SecVar.new(0)
    case var.type
      when :integer
        v = IntVar.new(var.add(amt))
      when :float
        v = FloatVar.new(var.add(amt))
      when :hex
        v = HexVar.new(var.value.dup)
        v.inc(amt)
      when :string
        v = StringVar.new(var.value.dup)
        v.inc(amt)
      when :ipv4
        v = IPv4Var.new(var.value.dup)
        v.inc(amt)
      when :array
        v = ArrayVar.new(var)
        v << dst_amt
      else
        raise ParseError, "Unhandled variable type #{var.type}"
    end
    v
  end

  def var_add_var(name, src)
    raise ParseError, "Improper math reference" if not src
    if name.type == :string then  # String has special properties
      case src.type
        when :string
          name.cat(src.value)
        when :ipv4
          name.cat(src.to_s)
        else
          self.var_add(name, src.to_i)
      end
    elsif name.type == :array then
      self.var_add(name, src)
    else
      if not src.type == :float then
        amt = src.to_i
      else
        amt = src
      end
      self.var_add(name, amt)
    end
  end

  def var_mult_var(var, src)
    raise ParseError, "Improper math reference" if not src
    if not src.type == :float then
      amt = src.to_i
    else
      amt = src
    end
    self.var_mult(var, amt)
  end

  def var_div_var(var, src)
    raise ParseError, "Improper math reference" if not src
    if not src.type == :float then
      amt = src.to_i
    else
      amt = src
    end
    self.var_div(var, amt)
  end

  def var_sub_var(var, src)
    raise ParseError, "Improper math reference" if not src
    if not src.type == :float then
      amt = src.to_i
    else
      amt = src
    end
    self.var_sub(var, amt)
  end

  def var_sub(var, amt)
    if not amt.type == :float then
      amt = amt.to_i
    end
    case var.type
      when :integer
        v = IntVar.new(var.sub(amt))
      when :float
        v = FloatVar.new(var.sub(amt))
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

  def var_inc_var(dst_name, src)
    raise ParseError, "#{dst_name} not defined" if not @var.has_key? dst_name
    dst = @var[dst_name]
    @var[dst_name] = self.var_add_var(dst, src)
    @var[dst_name]
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

  def slice_var(name, index)
    if @var.has_key? name then
      if @var[name].class.method_defined? :slice then
        return @var[name].slice(index)
      else
        raise RuntimeError, "#{@var[name].class} does not support array indexing"
      end
    else
      raise ParseError, "#{name} not assigned"
    end
  end

  def var_range(start, stop)
    raise RuntimeError, "Can not perform a range translation from two different types of variables." if not start.class == stop.class
    raise RuntimeError, "Can not iterate #{start.class}" if not start.class.method_defined? :succ
    raise RuntimeError, "Can not iterate #{stop.class}" if not stop.class.method_defined? :succ
    ArrayVar.new((start..stop).to_a)
  end

  def is_match?(val1, val2)
    val1.value =~ /#{val2.value}/
  end

  def is_eq?(val1, val2)
    val1.value == val2.value
  end

  def is_lt?(val1, val2)
    raise RuntimeError, "Comparison of unsimiliar types #{val1.type} #{val2.type}" if val1.type != val2.type
    return true if val1.compare(val2) < 0
    false
  end

  def is_gt?(val1, val2)
    raise RuntimeError, "Comparison of unsimiliar types #{val1.type} #{val2.type}" if val1.type != val2.type
    return true if val1.compare(val2) > 0
    false
  end

  def is_le?(val1, val2)
    raise RuntimeError, "Comparison of unsimiliar types #{val1.type} #{val2.type}" if val1.type != val2.type
    return true if val1.compare(val2) != 1
    false
  end

  def is_ge?(val1, val2)
    raise RuntimeError, "Comparison of unsimiliar types #{val1.type} #{val2.type}" if val1.type != val2.type
    return true if val1.compare(val2) != -1
    false
  end

  def is_ne?(val1, val2)
    val1.value != val2.value
  end

  def sec_puts(var)
    if var == nil then
      puts "(nil)"
    elsif var.is_a? TrueClass or var.is_a? FalseClass then
      puts var
    elsif var.is_a? Symbol then
      puts var.to_s
    elsif var.type == :string then
      s = var.to_s.dup
      s = variable_subst(s)
      s.gsub!("\\n", "\n")
      puts s
    else
      var = var.auto_color if @color == :full
      puts var
    end
  end

  def sec_print(var)
    if var.is_a? TrueClass or var.is_a? FalseClass then
      print var
    elsif var.type == :string then
      s = var.to_s.dup
      s = variable_subst(s)
      s.gsub!("\\n", "\n")
      print s
    else
      var = var.auto_color if @color == :full
      print var
    end
  end

  def shell(cmd)
    cmd = variable_subst(cmd)
    StringVar.new(`#{cmd}`)
  end

  def variable_subst(str)
    substs = str.scan(/\$[a-zA-Z][a-zA-Z0-9_]*/)
    substs.each do |subst|
      subst.gsub!("$","")
      if @var.has_key? subst
        if @color == :full then
          str.gsub!("$#{subst}", @var[subst].auto_color.value)
        else
          str.gsub!("$#{subst}", @var[subst].to_s)
        end
      else
        raise RuntimeError, "Invalid variable substitution of #{subst} in #{str}"
      end
    end
    str
  end

  def if_stmt(cond, code_blocks, else_blocks=nil)
    case cond
      when true
        @parser.clear_tokens
        code_blocks.each do |code|
          @parser.parse code
        end
      when false
        if else_blocks then
          @parser.clear_tokens
          else_blocks.each do |code|
            @parser.parse code
          end
        end
      else
        raise RuntimeError, "Condition not true/false #{cond}"
    end
  end

  def while_stmt(cond, code_blocks)
    case cond
      when true
        @parser.clear_tokens
        code_blocks.each do |code|
          @parser.parse code if code.size > 0
        end
        @parser.loop
      when false
      else
        raise RuntimeError, "While Condition not true/false #{cond}"
    end
  end

  def call_func(function, args)
    function.gsub!(/\($/, "")
    if @func.exists? function then
      return @func.call(function, args)
    else
      raise RuntimeError, "Unknown function #{function}"
    end
  end

  def add_func(function, args, body)
    function.gsub!(/\($/, "")
    function.gsub!(/^def /, "")
    args.gsub!(/[\s\t]+/, "")
    args = args.split(',')
    if not @func.exists? function then
      if body.is_a? Method then
        return @func.add_func(function, :callback, args, body)
      else
        return @func.add_func(function, :external, args, body)
      end
    else
      raise RuntimeError, "Function #{function} already defined"
    end
  end

end
