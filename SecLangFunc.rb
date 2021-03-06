require 'digest'
require 'uri'

class SecFunc
  attr_reader :name, :type, :args, :body
  attr_accessor :parser
 
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
    add_func("len", :internal, ["array"], :var_len)
    add_func("rand", :internal, ["min", "max"], :rand)
    add_func("md5", :internal, ["str"], :to_md5)
    add_func("sha256", :internal, ["str"], :to_sha256)
    add_func("uuencode", :internal, ["str"], :uuencode)
    add_func("uudecode", :internal, ["uu"], :uudecode)
    add_func("urlencode", :internal, ["str"], :uri_encode)
    add_func("urldecode", :internal, ["str"], :uri_decode)
    add_func("fail", :internal, ["str"], :fail)
    add_func("info", :internal, ["str"], :info)
    add_func("pass", :internal, ["str"], :pass)
    add_func("color", :internal, ["str"], :set_color)
    add_func("blink", :internal, ["str"], :blink)
    add_func("bold", :internal, ["str"], :bold)
    add_func("black", :internal, ["str"], :black)
    add_func("red", :internal, ["str"], :red)
    add_func("green", :internal, ["str"], :green)
    add_func("yellow", :internal, ["str"], :yellow)
    add_func("blue", :internal, ["str"], :blue)
    add_func("magenta", :internal, ["str"], :magenta)
    add_func("cyan", :internal, ["str"], :cyan)
    add_func("grey", :internal, ["str"], :grey)
  end

  def exists? func
    return @funcs.has_key? func
  end

  def call(func, args)
    if @funcs[func].type == :internal then
      f = @funcs[func]
      #return self.send(f.body, args[1..args.length-2])
      return self.send(f.body, args)
    elsif @funcs[func].type == :callback then
      #return f.body.call args[1..args.length-2]
      return f.body.call args
    else
      #return @funcs[func].exec(args[1..args.length-2])
      # ensure color setting is up to date
      @funcs[func].parser.color(@core.color)
      return @funcs[func].exec(args)
    end
  end

  def add_func(name, type, args, body)
    raise RuntimeError "#{name} function already exists" if @funcs.has_key? name
    @funcs[name] = SecFunc.new(name, type, args, body)
    if not type == :internal then
      @funcs[name].parser.color(@core.color) #inherit color
    end
  end

  private
  def str(args)
    if args[0].is_a? HexVar then
      args[0].to_ascii
    else
      return StringVar.new(args[0].to_s)
    end
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
    elsif val.class.method_defined? :to_hex then
      val.to_hex
    else
      HexVar.new(val.value)
    end
  end

  def var_len(var)
    val = var[0]
    if val.is_a? StringVar or val.is_a? ArrayVar
      return val.length
    else
      raise RuntimeError, "#{var} does not support length queries"
    end
  end

  def to_md5(args)
    StringVar.new(Digest::MD5.hexdigest(args[0].to_s))
  end

  def to_sha256(args)
    StringVar.new(Digest::SHA256.hexdigest(args[0].to_s))
  end

  def uuencode(args)
    StringVar.new([args[0].value].pack('u*'))
  end

  def uudecode(args)
    StringVar.new(args[0].value.unpack('u*')[0])
  end

  def uri_encode(args)
    StringVar.new(URI.escape(args[0].value))
  end

  def uri_decode(args)
    StringVar.new(URI.unescape(args[0].value))
  end

  def rand(args)
    rains RuntimeError, "rand takes 2 arguments" if not args.size == 2
    min = args[0]
    max = args[1]
    prng = Random.new
    FloatVar.new(prng.rand(min..max))
  end

  def info(msg)
    if @core.color == :none then
      m = StringVar.new(" [ - ] ") + msg[0]
    else
      m = StringVar.new(" [ ").grey + StringVar.new("-").set_color(0) + StringVar.new(" ] ").grey + msg[0]
    end
    @core.sec_puts(m)
  end

  def pass(msg)
    if @core.color == :none then
      m = StringVar.new(" [ + ] ") + msg[0]
    else
      m = StringVar.new(" [ ").grey + StringVar.new("+").green + StringVar.new(" ] ").grey + msg[0]
    end
    @core.sec_puts(m)
  end

  def fail(msg)
    if @core.color == :none then
      m = StringVar.new(" [ ! ] ") + msg[0]
    else
      m = StringVar.new(" [ ").grey + StringVar.new("!").red + StringVar.new(" ] ").grey + msg[0]
    end
    @core.sec_puts(m)
  end

  def set_color(args)
    return @core.color_level if args.size == 0
    level = args[0]
    case level.value
    when "none", "off"
      @core.color = :none
    when "on"
      @core.color = :on
    when "full"
      @core.color = :full
    else
      raise RuntimeError, "Unknown color state #{level}"
    end
    @core.color_level
  end

  def blink(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.blink
  end

  def bold(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.bold
  end

  def black(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.black
  end

  def red(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.red
  end

  def green(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.green
  end

  def yellow(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.yellow
  end

  def blue(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.blue
  end

  def magenta(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.magenta
  end

  def cyan(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.cyan
  end

  def grey(args)
     return if not args
     return args[0] if @core.color == :none
     str = args[0]
     str = args[0].to_s if not args[0].is_a? StringVar
     return if not str.is_a? StringVar
     str.grey
  end
end
