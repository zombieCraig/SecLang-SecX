require "./SecVar"
require "./SecLangFunc"

class SecLangCore
  attr_accessor :var

  def initialize(parser)
    @parser = parser
    @func = SecLangFunc.new(self)
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
    if name.type == :string then  # String has special properties
      case src.type
        when :string
          name.cat(src.value)
        when :ipv4
          name.cat(src.to_s)
        else
          self.var_add(name, src.to_i)
      end
    else
      amt = src.to_i
      self.var_add(name, amt)
    end
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
        str.gsub!("$#{subst}", @var[subst].to_s)
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
      return @func.add_func(function, :external, args, body)
    else
      raise RuntimeError, "Function #{function} already defined"
    end
  end

end
