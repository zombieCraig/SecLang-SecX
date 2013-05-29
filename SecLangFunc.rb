class SecFunc
  attr_reader :name, :type, :args, :body
 
  def initialize(name, type, args, body)
    @name = name
    @type = type
    @def_args = args
    @body = body
    if type == :internal
      @parser = nil
    else
      @parser = SecLang.new
    end
  end

  def exec(args)
    vars = assign_args args
    vars.each do |var_name, var_value|
      if var_value.type == :string then
        value = "\"#{var_value}\""
      else
        value = var_value
      end
      init = "#{var_name} = #{value}\n"
      @parser.parse init
    end
    result = nil
    @body.each do |code|
      result = @parser.parse code
    end
    result
  end

  private
  def assign_args args
    assigned = {}
    arg_count = 0
    @def_args.each do |var|
      assigned[var] = args[arg_count] if args[arg_count]
      arg_count += 1
    end
    assigned
  end
end

class SecLangFunc

  def initialize(core)
    @core = core
    @funcs = {}
    load_internal_funcs
  end

  def load_internal_funcs
    add_func("str", :internal, ["val"], :str)
    add_func("int", :internal, ["val"], :int)
    add_func("hex", :internal, ["val"], :hex)
  end

  def exists? func
    return @funcs.has_key? func
  end

  def call(func, args)
    if @funcs[func].type == :internal then
      f = @funcs[func]
      return self.send(f.body, args[1..args.length-2])
    elsif @funcs[func].type == :callback then
      return f.body.call args[1..args.length-2]
    else
      return @funcs[func].exec(args[1..args.length-2])
    end
  end

  def add_func(name, type, args, body)
    raise RuntimeError "#{name} function already exists" if @funcs.has_key? name
    @funcs[name] = SecFunc.new(name, type, args, body)
  end

  private
  def str(args)
    return StringVar.new(args[0].to_s)
  end

  def int(args)
    return IntVar.new(args[0].to_i)
  end

  def hex(args)
    val = args[0]
    if val.is_a? IntVar
      HexVar.new(val.to_s(16))
    elsif val.is_a? HexVar
      val
    else
      HexVar.new(val.value)
    end
  end

end
