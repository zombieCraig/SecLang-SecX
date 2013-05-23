
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
             result = val[0] == val[2]
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
             result = puts val[1]
           }
           |
           PRINTTOK commands
           {
             result = print val[1]
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
           vardec_cmd
           |
           varinc_cmd
           |
           variable_assignment
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
          VAR VARINCAMT DIGITS
          {
		result = @s.var_inc(val[0], val[2])
          }
          |
          VAR VARINCAMT VAR
          {
             	result = @s.var_inc_var(val[0], val[2])
          }
          ;

variable_assignment:
          VAR EQUAL command
          {
                r = val[2]
                if r.is_a? SecVar
                  result = @s.add_var(val[0], r)
                elsif r.is_a? Integer
		  result = @s.add_var(val[0], IntVar.new(val[2]))
                else r.is_a? String
		  result = @s.add_var(val[0], StringVar.new(val[2]))
                end
		result
          }
          |
          VAR EQUAL VAR
          {
		result = @s.copy_var(val[0], val[2])
          }
          |
          VAR EQUAL DIGITS
          {
		result = @s.add_var(val[0], IntVar.new(val[2]))
          }
          |
          VAR EQUAL quotedtext
          {
		result = @s.add_var(val[0], StringVar.new(val[2]))
          }
          |
          VAR EQUAL IPV4ADDR
          {
		result = @s.add_var(val[0], IPv4Var.new(val[2]))
          }
          |
          VAR EQUAL HEXVALUE
          {
		result = @s.add_var(val[0], HexVar.new(val[2]))
          }
          |
          VAR EQUAL LPAREN commands RPAREN
          {
                t = val[3]
		result = @s.add_var(val[0], StringVar.new(t.to_s))
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
  end

  def check_syntax( str )
    @syntax_check = true
    res = parse(str)
    @syntax_check = false
    return res
  end

  def parse(str)
    @script = str
    state = :MAIN
    tokens = []
    last_state = []
    last_state.push state
    scanner = StringScanner.new(str)
    
    until scanner.eos?
      case
        when state == :MAIN
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
            when m = scanner.scan(/\(/)
              tokens.push [:LPAREN, m]
            when m = scanner.scan(/\)/)
              tokens.push [:RPAREN, m]
            when m = scanner.scan(/\"/)
              tokens.push [:QUOTE, m]
              last_state.push state
              state = :QUOTED 
            when m = scanner.scan(/\'/)
              tokens.push [:SINGLE_QUOTE, m]
              last_state.push state
              state = :SINGLE_QUOTED
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
            when m = scanner.scan(/;/)
              tokens.push [:SEMICOLON, m]
            when scanner.scan(/[ \t\r\n]/)
              # ignore whtiespace
            else
              puts "Syntax error around #{scanner.pos} #{scanner.rest}"
              return -1
          end
       when state == :QUOTED
         case
           when m = scanner.scan(/\"/)
             tokens.push [:QUOTE, m]
             state = last_state.pop
           when m = scanner.scan(/[^"]+/)
             tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end
       when state == :SINGLE_QUOTED
         case
           when m = scanner.scan(/\'/)
             tokens.push [:SINGLE_QUOTE, m]
             state = last_state.pop
           when m = scanner.scan(/[^']+/)
             tokens.push [:DATA, m]
           when m = scanner.scan(/[ \t\r\n]/)
             # ignore whitespace
         end

       end
    end
    tokens.push [false, false]

    if last_state.size > 1 then
      puts "Unclosed brackets (#{last_state.pop.to_s})"
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

