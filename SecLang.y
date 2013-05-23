
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
           | truth_stmt ANDTOK commands
           {
             result = val[0] && val[2]
           }
           | truth_stmt ORTOK commands
           {
             result = val[0] || val[2]
           }
           |
           truth_stmt EQ commands
           {
             result = @s.is_eq?(val[0], val[2])
           }
           |
           truth_stmt GT commands
           {
             result = val[0] > val[2]
           }
           |
           truth_stmt LT commands
           {
             result = val[0] < val[2]
           }
           |
           truth_stmt LE commands
           {
             result = val[0] <= val[2]
           }
           |
           truth_stmt GE commands
           {
             result = val[0] >= val[2]
           }
           |
           truth_stmt NE commands
           {
             result = val[0] != val[2]
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
           set_mode_cmd
           |
           int_cmd
           |
           hex_cmd
           |
           str_cmd
           |
           vardec_cmd
           |
           varinc_cmd
           |
           backtick_cmd
           ;

backtick_cmd:
          BACKTICK DATA BACKTICK
          {
		result = @s.shell(val[1])
          }
          ;

str_cmd:
          STRTOK LPAREN truth_stmt RPAREN
          {
		result = @s.str(val[2])
          }
          ;

int_cmd:
          INTTOK LPAREN truth_stmt RPAREN
          {
		result = @s.int(val[2])
          }
          ;

hex_cmd:
         HEXTOK LPAREN truth_stmt RPAREN
         {
		result = @s.hex(val[2])
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
require './SecLangCore'

---- inner ----    
  def initialize
    @syntax_check = false
    @s = SecLangCore.new
    @state = :MAIN
    @last_state = []
    @last_state.push @state
  end

  def check_syntax( str )
    @syntax_check = true
    res = parse(str)
    @syntax_check = false
    return res
  end

  def parse(str)
    @script = str
    tokens = []
    scanner = StringScanner.new(str)
    
    until scanner.eos?
      case
        when @state == :MAIN
          case
            when m = scanner.scan(/puts/)
              tokens.push [:PUTSTOK, m]
            when m = scanner.scan(/print/)
              tokens.push [:PRINTTOK, m]
            when m = scanner.scan(/type/)
              tokens.push [:TYPETOK, m]
            when m = scanner.scan(/mode/)
              tokens.push [:GETMODETOK, m]
            when m = scanner.scan(/set_mode/)
              tokens.push [:SETMODETOK, m]
            when m = scanner.scan(/int/)
              tokens.push [:INTTOK, m]
            when m = scanner.scan(/str/)
              tokens.push [:STRTOK, m]
            when m = scanner.scan(/hex/)
              tokens.push [:HEXTOK, m]
            when m = scanner.scan(/\(/)
              tokens.push [:LPAREN, m]
            when m = scanner.scan(/\)/)
              tokens.push [:RPAREN, m]
            when m = scanner.scan(/\"/)
              tokens.push [:QUOTE, m]
              @last_state.push @state
              @state = :QUOTED 
            when m = scanner.scan(/\'/)
              tokens.push [:SINGLE_QUOTE, m]
              @last_state.push @state
              @state = :SINGLE_QUOTED
            when m = scanner.scan(/\/\*/)
              @last_state.push @state
              @state = :BLOCK_COMMENT
            when m = scanner.scan(/,/)
              tokens.push [:COMMA, m]
            when m = scanner.scan(/==/)
              tokens.push [:EQ, m]
            when m = scanner.scan(/</)
              tokens.push [:LT, m]
            when m = scanner.scan(/>/)
              tokens.push [:GT, m]
            when m = scanner.scan(/>=/)
              tokens.push [:GE, m]
            when m = scanner.scan(/<=/)
              tokens.push [:LE, m]
            when m = scanner.scan(/!=/)
              tokens.push [:NE, m]
            when m = scanner.scan(/\|\|/)
              tokens.push [:ORTOK, m]
            when m = scanner.scan(/&&/)
              tokens.push [:ANDTOK, m]
            when m = scanner.scan(/=/)
              tokens.push [:EQUAL, m]
            when m = scanner.scan(/(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/)
              tokens.push [:IPV4ADDR, m]
            when m = scanner.scan(/0x[0-9a-fA-F]+/)
              tokens.push [:HEXVALUE, m]
            when m = scanner.scan(/\+=/)
              tokens.push [:VARINCAMT, m]
            when m = scanner.scan(/-=/)
              tokens.push [:VARDECAMT, m]
            when m = scanner.scan(/:[a-zA-Z][a-zA-Z0-9_-]*/)
              tokens.push [:SYMBOL, m]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*\-\-/)
              tokens.push [:VARDECTOK, m ]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*\+\+/)
              tokens.push [:VARINCTOK, m ]
            when m = scanner.scan(/[a-zA-Z][a-zA-Z0-9_]*/)
              tokens.push [:VAR, m]
            when m = scanner.scan(/\d+/)
              tokens.push [:DIGITS, m]
            when m = scanner.scan(/\+/)
              tokens.push [:ADD, m]
            when m = scanner.scan(/\-/)
              tokens.push [:SUB, m]
            when m = scanner.scan(/\`/)
              tokens.push [:BACKTICK, m]
              @last_state.push @state
              @state = :BACKTICKS
            when m = scanner.scan(/;/)
              tokens.push [:SEMICOLON, m]
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
       when @state == :BACKTICKS
         case
           when m = scanner.scan(/\`/)
             tokens.push [:BACKTICK, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^`]+/)
             tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when @state == :QUOTED
         case
           when m = scanner.scan(/\"/)
             tokens.push [:QUOTE, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^"]+/)
             tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when @state == :SINGLE_QUOTED
         case
           when m = scanner.scan(/\'/)
             tokens.push [:SINGLE_QUOTE, m]
             @state = @last_state.pop
           when m = scanner.scan(/[^']+/)
             tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end

       end
    end
    tokens.push [false, false]

    if @last_state.size > 1 and not @state == :BLOCK_COMMENT then
      puts "Unclosed brackets (#{@last_state.pop.to_s})"
      return -1
    end

    truth = yyparse(tokens, :each)
  end

  def on_error(error_token_id, error_value, value_stack)
    msg = "parse error "
    msg << "after #{value_stack.last} " if value_stack.length > 1
    msg << "on #{token_to_str(error_token_id)} #{error_value}"
    raise ParseError, msg
  end

---- footer ----

