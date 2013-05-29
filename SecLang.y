
class SecLang

rule

	commands: /* empty */ { result = false }
           | LPAREN commands RPAREN ANDTOK commands
           {
             result = val[1] && val[4]
           }
           | LPAREN commands RPAREN ORTOK commands
           {
             result = val[1] || val[4]
           }
           | LPAREN commands RPAREN ADD commands
           {
             result = @s.var_add_var(val[1], val[4])
           }
           | LPAREN commands RPAREN SUB commands
           {
             result = @s.var_sub_var(val[1], val[4])
           }
           | variable_assignment
           | truth_stmt SEMICOLON commands
           | if_stmt
           | while_stmt
           | truth_stmt ANDTOK commands
           {
             result = val[0] && val[2]
           }
           | truth_stmt ORTOK commands
           {
             result = val[0] || val[2]
           }
           |
           truth_stmt MATCHTOK commands
           {
             result = @s.is_match?(val[0], val[2])
           }
           |
           truth_stmt EQ commands
           {
             result = @s.is_eq?(val[0], val[2])
           }
           |
           truth_stmt GT commands
           {
             result = @s.is_gt?(val[0],val[2])
           }
           |
           truth_stmt LT commands
           {
             result = @s.is_lt?(val[0],val[2])
           }
           |
           truth_stmt LE commands
           {
             result = @s.is_le?(val[0],val[2])
           }
           |
           truth_stmt GE commands
           {
             result = @s.is_ge?(val[0],val[2])
           }
           |
           truth_stmt NE commands
           {
             result = @s.is_ne?(val[0],val[2])
           }
           |
           truth_stmt ADD commands
           {
             result = @s.var_add_var(val[0], val[2])
           }
           |
           truth_stmt SUB commands
           {
             result = @s.var_sub_var(val[0], val[2])
           }
           |
           PUTSTOK commands
           {
             result = @s.sec_puts(val[1])
           }
           |
           PRINTTOK commands
           {
             result = @s.sec_print(val[1])
           }
           | truth_stmt
           ;

if_stmt:
           IFTOK LPAREN commands RPAREN OBRACE BLOCK EBRACE ELSETOK OBRACE BLOCK EBRACE
           {
		result = @s.if_stmt(val[2], val[5], val[9])
           }
           |
           IFTOK LPAREN commands RPAREN OBRACE BLOCK EBRACE
           {
		result = @s.if_stmt(val[2], val[5])
           }
           ;

while_stmt:
           WHILETOK LPAREN commands RPAREN OBRACE BLOCK EBRACE
           {
                @nested_stack.push @tokens
 		result = @s.while_stmt(val[2], val[5])
           }
           ;

truth_stmt:
           command
           |
           not_command
           |
           quotedtext
           {
		result = StringVar.new(val[0])
           }
           |
           DIGITS
           {
		result = IntVar.new(val[0])
           }
           |
           VAR
           {
                result = @s.get_var(val[0])
           }
           |
           HEXVALUE
           {
		result = HexVar.new(val[0])
           }
           |
           IPV4ADDR
           {
		result = IPv4Var.new(val[0])
           }
           ;

not_command:
           NOTTOK command
           {
                  result = val[1] ? false : true
           }
           ;

command:
           type_cmd
           |
           get_mode_cmd
           |
           vardec_cmd
           |
           set_mode_cmd
           |
           varinc_cmd
           |
           backtick_cmd
           |
           call_func
           |
           define_func
           ;

define_func:
          DEFTOK ARGS_DEF RPAREN OBRACE BLOCK EBRACE
          {
		result = @s.add_func(val[0], val[1], val[4])
          }
          ;

call_func:
          FUNCTOK args RPAREN
          {
		result = @s.call_func(val[0], val[1].flatten)
          }
          ;

args:    /* empty */ { result = nil }
          | truth_stmt { result = [val[0] ] }
          | truth_stmt COMMA args { result = [val[0], val[2]] } 
          ; 

backtick_cmd:
          BACKTICK DATA BACKTICK
          {
		result = @s.shell(val[1])
          }
          ;

type_cmd:
          TYPETOK LPAREN VAR RPAREN
          {
		result = @s.var_type(val[2])
          }
          ;

set_mode_cmd:
          SETMODETOK LPAREN VAR COMMA SYMBOL RPAREN
          {
		result = @s.var_set_mode(val[2], val[4])
          }
          ;

get_mode_cmd:
          GETMODETOK LPAREN VAR RPAREN
          {
		result = @s.var_get_mode(val[2])
          }
          ;

vardec_cmd:
          VARDECTOK
          {
		result = @s.var_dec(val[0])
          }
          |
          VAR VARDECAMT DIGITS
          {
		result = @s.var_dec(val[0], val[2])
          }
          |
          VAR VARDECAMT VAR
          {
             	result = @s.var_dec_var(val[0], val[2])
          }
          ;

varinc_cmd:
          VARINCTOK
          {
		result = @s.var_inc(val[0])
          }
          |
          /*VAR VARINCAMT DIGITS
          {
		result = @s.var_inc(val[0], val[2])
          }
          |*/
          VAR VARINCAMT truth_stmt
          {
             	result = @s.var_inc_var(val[0], val[2])
          }
          ;

variable_assignment:
          VAR EQUAL commands
          {
		result = @s.add_var(val[0], val[2])
          }
          ;

quotedtext:
         QUOTE DATA QUOTE
         {
		result = val[1]
         }
         | SINGLE_QUOTE DATA SINGLE_QUOTE
         {
		result = val[1]
         }
         ;

end

---- header ----

# generated by racc

require 'strscan'
require "#{File.dirname(__FILE__)}/SecLangCore"

---- inner ----    
  attr_accessor :script

  def initialize
    @syntax_check = false
    @s = SecLangCore.new(self)
    @state = :MAIN
    @last_state = []
    @last_state.push @state
    @nested_stack = Array.new
    @depth = 0
  end

  def clear_tokens
    @tokens = []
  end

  def check_syntax( str )
    @syntax_check = true
    res = parse(str)
    @syntax_check = false
    @tokens = []
    return res
  end

  def parse(str)
    @script = str
    @tokens = [] if not @tokens
    scanner = StringScanner.new(str)
    
    until scanner.eos?
      case
        when @state == :MAIN
          case
            when m = scanner.scan(/puts/)
              @tokens.push [:PUTSTOK, m]
            when m = scanner.scan(/print/)
              @tokens.push [:PRINTTOK, m]
            when m = scanner.scan(/type/)
              @tokens.push [:TYPETOK, m]
            when m = scanner.scan(/mode/)
              @tokens.push [:GETMODETOK, m]
            when m = scanner.scan(/set_mode/)
              @tokens.push [:SETMODETOK, m]
            when m = scanner.scan(/hex/)
              @tokens.push [:HEXTOK, m]
            when m = scanner.scan(/if/)
              @tokens.push [:IFTOK, m]
            when m = scanner.scan(/else/)
              @tokens.push [:ELSETOK, m]
            when m = scanner.scan(/while/)
              @tokens.push [:WHILETOK, m]
            when m = scanner.scan(/{/)
              @tokens.push [:OBRACE, m]
              @last_state.push @state
              @state = :CODE_BLOCK
              @code_blocks = Array.new
              @code_segment = String.new
              @depth = 1
            when m = scanner.scan(/\(/)
              @tokens.push [:LPAREN, m]
            when m = scanner.scan(/\)/)
              @tokens.push [:RPAREN, m]
            when m = scanner.scan(/\"/)
              @tokens.push [:QUOTE, m]
              @last_state.push @state
              @state = :QUOTED 
            when m = scanner.scan(/\'/)
              @tokens.push [:SINGLE_QUOTE, m]
              @last_state.push @state
              @state = :SINGLE_QUOTED
            when m = scanner.scan(/\/\*/)
              @last_state.push @state
              @state = :BLOCK_COMMENT
            when m = scanner.scan(/,/)
              @tokens.push [:COMMA, m]
            when m = scanner.scan(/=~/)
              @tokens.push [:MATCHTOK, m]
            when m = scanner.scan(/==/)
              @tokens.push [:EQ, m]
            when m = scanner.scan(/>=/)
              @tokens.push [:GE, m]
            when m = scanner.scan(/<=/)
              @tokens.push [:LE, m]
            when m = scanner.scan(/</)
              @tokens.push [:LT, m]
            when m = scanner.scan(/>/)
              @tokens.push [:GT, m]
            when m = scanner.scan(/!=/)
              @tokens.push [:NE, m]
            when m = scanner.scan(/\|\|/)
              @tokens.push [:ORTOK, m]
            when m = scanner.scan(/&&/)
              @tokens.push [:ANDTOK, m]
            when m = scanner.scan(/=/)
              @tokens.push [:EQUAL, m]
            when m = scanner.scan(/(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/)
              @tokens.push [:IPV4ADDR, m]
            when m = scanner.scan(/0x[0-9a-fA-F]+/)
              @tokens.push [:HEXVALUE, m]
            when m = scanner.scan(/\+=/)
              @tokens.push [:VARINCAMT, m]
            when m = scanner.scan(/-=/)
              @tokens.push [:VARDECAMT, m]
            when m = scanner.scan(/def [a-zA-Z_][a-zA-Z0-9_]*\(/)
              @tokens.push [:DEFTOK, m]
              @last_state.push @state
              @state = :FUNC_DEFINE
            when m = scanner.scan(/[a-zA-Z_][a-zA-Z0-9_]*\(/)
              @tokens.push [:FUNCTOK, m]
            when m = scanner.scan(/:[a-zA-Z][a-zA-Z0-9_-]*/)
              @tokens.push [:SYMBOL, m]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*\-\-/)
              @tokens.push [:VARDECTOK, m ]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*\+\+/)
              @tokens.push [:VARINCTOK, m ]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*/)
              @tokens.push [:VAR, m]
            when m = scanner.scan(/\d+/)
              @tokens.push [:DIGITS, m]
            when m = scanner.scan(/\+/)
              @tokens.push [:ADD, m]
            when m = scanner.scan(/\-/)
              @tokens.push [:SUB, m]
            when m = scanner.scan(/\`/)
              @tokens.push [:BACKTICK, m]
              @last_state.push @state
              @state = :BACKTICKS
            when m = scanner.scan(/;/)
              @tokens.push [:SEMICOLON, m]
            when scanner.scan(/[ \t\r\n]/)
              # ignore whtiespace
            else
              puts "Syntax error around #{scanner.pos} #{scanner.rest}"
              return -1
          end
       when @state == :BLOCK_COMMENT
         case
           when m = scanner.skip_until(/\*\//)
             @state = @last_state.pop
           when m = scanner.scan(/./)
           when m = scanner.scan(/[\r\n]/)
             # ignore
         end
       when @state == :FUNC_DEFINE
         case
           when m = scanner.scan(/\)/)
             @tokens.push [:RPAREN, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^\)]+/)
             @tokens.push [:ARGS_DEF, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when @state == :BACKTICKS
         case
           when m = scanner.scan(/\`/)
             @tokens.push [:BACKTICK, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^`]+/)
             @tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when @state == :CODE_BLOCK
         case
            when m = scanner.scan(/}/)
              @depth -= 1
              if @depth <= 0 then
                @state = @last_state.pop
                @code_blocks.push @code_segment
                @tokens.push [:BLOCK, @code_blocks]
                @tokens.push [:EBRACE, m]
                @depth = 0
              else
                @code_segment += m
              end
            when m = scanner.scan(/{/)
              @depth+= 1
              @code_segment += m
            when m = scanner.scan(/./)
              @code_segment += m
            when m = scanner.scan(/[\r\n]/)
              @code_segment += m
              @code_blocks.push @code_segment
              @code_segment = String.new
         end
       when @state == :QUOTED
         case
           when m = scanner.scan(/\"/)
             @tokens.push [:QUOTE, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^"]+/)
             @tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when @state == :SINGLE_QUOTED
         case
           when m = scanner.scan(/\'/)
             @tokens.push [:SINGLE_QUOTE, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^']+/)
             @tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end

       end
    end
    #@tokens.push [false, false]

    if @last_state.size > 1 and not 
       (@state == :BLOCK_COMMENT or @state == :CODE_BLOCK) then
      puts "Unclosed brackets (#{@last_state.pop.to_s})"
      return -1
    end

    # Only parse @tokens when back at MAIN
    truth = nil
    if @last_state.size == 1 then
      @tokens.push [false, false]
      truth = yyparse(@tokens, :each)
      @tokens = []
    end
    return truth
  end

  def on_error(error_token_id, error_value, value_stack)
    msg = "parse error "
    msg << "after #{value_stack.last} " if value_stack.length > 1
    msg << "on #{token_to_str(error_token_id)} #{error_value}"
    msg << "\n#{@tokens.inspect}"
    clear_tokens
    raise ParseError, msg
  end

  def loop
    @tokens = @nested_stack.pop
    yyparse(@tokens, :each) if @tokens.size > 0
  end

---- footer ----

