#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'


# generated by racc

require 'strscan'
require './SecLangCore'

class SecLang < Racc::Parser

module_eval(<<'...end SecLang.y/module_eval...', 'SecLang.y', 273)
  attr_accessor :script

  def initialize
    @syntax_check = false
    @s = SecLangCore.new(self)
    @state = :MAIN
    @last_state = []
    @last_state.push @state
    @nested_stack = Array.new
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
              @state = @last_state.pop
              @code_blocks.push @code_segment
              @tokens.push [:BLOCK, @code_blocks]
              @tokens.push [:EBRACE, m]
            when m = scanner.scan(/./)
              @code_segment += m
            when m = scanner.scan(/[\r\n]/)
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

...end SecLang.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     2,    40,    41,    48,    49,    39,    42,    43,    44,    45,
    46,    47,   107,     7,     8,     9,    97,    98,    99,   100,
    10,    14,    15,    16,    17,    18,    27,    54,    28,    55,
    29,     2,    30,    31,    69,    32,    33,    54,    34,    55,
    56,    35,    36,    68,     7,     8,     9,    54,    67,    55,
    66,    10,    14,    15,    16,    17,    18,    27,    88,    28,
    65,    29,     2,    30,    31,    89,    32,    33,    90,    34,
    84,    85,    35,    36,    91,     7,     8,     9,    92,    93,
    94,    95,    10,    14,    15,    16,    17,    18,    27,    96,
    28,    64,    29,     2,    30,    31,   101,    32,    33,   102,
    34,   103,    63,    35,    36,   105,     7,     8,     9,   106,
    70,    59,    53,    10,    14,    15,    16,    17,    18,    27,
    52,    28,    37,    29,     2,    30,    31,   112,    32,    33,
   113,    34,   114,   115,    35,    36,   116,     7,     8,     9,
   117,   118,   119,   120,    10,    14,    15,    16,    17,    18,
    27,   121,    28,   122,    29,     2,    30,    31,   123,    32,
    33,   124,    34,   125,   nil,    35,    36,   nil,     7,     8,
     9,   nil,   nil,   nil,   nil,    10,    14,    15,    16,    17,
    18,    27,   nil,    28,   nil,    29,     2,    30,    31,   nil,
    32,    33,   nil,    34,   nil,   nil,    35,    36,   nil,     7,
     8,     9,   nil,   nil,   nil,   nil,    10,    14,    15,    16,
    17,    18,    27,   nil,    28,   nil,    29,     2,    30,    31,
   nil,    32,    33,   nil,    34,   nil,   nil,    35,    36,   nil,
     7,     8,     9,   nil,   nil,   nil,   nil,    10,    14,    15,
    16,    17,    18,    27,   nil,    28,   nil,    29,     2,    30,
    31,   nil,    32,    33,   nil,    34,   nil,   nil,    35,    36,
   nil,     7,     8,     9,   nil,   nil,   nil,   nil,    10,    14,
    15,    16,    17,    18,    27,   nil,    28,   nil,    29,     2,
    30,    31,   nil,    32,    33,   nil,    34,   nil,   nil,    35,
    36,   nil,     7,     8,     9,   nil,   nil,   nil,   nil,    10,
    14,    15,    16,    17,    18,    27,   nil,    28,   nil,    29,
     2,    30,    31,   nil,    32,    33,   nil,    34,   nil,   nil,
    35,    36,   nil,     7,     8,     9,   nil,   nil,   nil,   nil,
    10,    14,    15,    16,    17,    18,    27,   nil,    28,   nil,
    29,     2,    30,    31,   nil,    32,    33,   nil,    34,   nil,
   nil,    35,    36,   nil,     7,     8,     9,   nil,   nil,   nil,
   nil,    10,    14,    15,    16,    17,    18,    27,   nil,    28,
   nil,    29,     2,    30,    31,   nil,    32,    33,   nil,    34,
   nil,   nil,    35,    36,   nil,     7,     8,     9,   nil,   nil,
   nil,   nil,    10,    14,    15,    16,    17,    18,    27,   nil,
    28,   nil,    29,     2,    30,    31,   nil,    32,    33,   nil,
    34,   nil,   nil,    35,    36,   nil,     7,     8,     9,   nil,
   nil,   nil,   nil,    10,    14,    15,    16,    17,    18,    27,
   nil,    28,   nil,    29,     2,    30,    31,   nil,    32,    33,
   nil,    34,   nil,   nil,    35,    36,   nil,     7,     8,     9,
   nil,   nil,   nil,   nil,    10,    14,    15,    16,    17,    18,
    27,   nil,    28,   nil,    29,     2,    30,    31,   nil,    32,
    33,   nil,    34,   nil,   nil,    35,    36,   nil,     7,     8,
     9,   nil,   nil,   nil,   nil,    10,    14,    15,    16,    17,
    18,    27,   nil,    28,   nil,    29,     2,    30,    31,   nil,
    32,    33,   nil,    34,   nil,   nil,    35,    36,   nil,     7,
     8,     9,   nil,   nil,   nil,   nil,    10,    14,    15,    16,
    17,    18,    27,   nil,    28,   nil,    29,     2,    30,    31,
   nil,    32,    33,   nil,    34,   nil,   nil,    35,    36,   nil,
     7,     8,     9,   nil,   nil,   nil,   nil,    10,    14,    15,
    16,    17,    18,    27,   nil,    28,   nil,    29,     2,    30,
    31,   nil,    32,    33,   nil,    34,   nil,   nil,    35,    36,
   nil,     7,     8,     9,   nil,   nil,   nil,   nil,    10,    14,
    15,    16,    17,    18,    27,   nil,    28,   nil,    29,     2,
    30,    31,   nil,    32,    33,   nil,    34,   nil,   nil,    35,
    36,   nil,     7,     8,     9,   nil,   nil,   nil,   nil,    10,
    14,    15,    16,    17,    18,    27,   nil,    28,   nil,    29,
     2,    30,    31,   nil,    32,    33,   nil,    34,   nil,   nil,
    35,    36,   nil,     7,     8,     9,   nil,   nil,   nil,   nil,
    10,    14,    15,    16,    17,    18,    27,   nil,    28,   nil,
    29,     2,    30,    31,   nil,    32,    33,   nil,    34,   nil,
   nil,    35,    36,   nil,     7,     8,     9,   nil,   nil,   nil,
   nil,    10,    14,    15,    16,    17,    18,    27,   nil,    28,
   nil,    29,   nil,    30,    31,   nil,    32,    33,   nil,    34,
   nil,   nil,    35,    36,    14,    60,    16,    17,    18,    27,
   nil,    28,   nil,    29,   nil,    30,    31,   nil,    32,    33,
   nil,    34,   nil,   nil,    35,    36,    14,    60,    16,    17,
    18,    27,   nil,    28,   nil,    29,   nil,    30,    31,   nil,
    32,    33,   nil,    34,   nil,   nil,    35,    36,    14,    60,
    16,    17,    18,    27,   nil,    28,   nil,    29,   nil,    30,
    31,   nil,    32,    33,   nil,    34,    58,   nil,    35,    36,
    27,   nil,    28,   nil,    29,   nil,    30,    31,   nil,    32,
    33,   nil,    34 ]

racc_action_check = [
     0,     4,     4,     4,     4,     4,     4,     4,     4,     4,
     4,     4,    94,     0,     0,     0,    70,    70,    70,    70,
     0,     0,     0,     0,     0,     0,     0,    60,     0,    60,
     0,   100,     0,     0,    37,     0,     0,    15,     0,    15,
    15,     0,     0,    36,   100,   100,   100,    58,    35,    58,
    32,   100,   100,   100,   100,   100,   100,   100,    59,   100,
    31,   100,     2,   100,   100,    61,   100,   100,    62,   100,
    54,    54,   100,   100,    63,     2,     2,     2,    64,    65,
    66,    67,     2,     2,     2,     2,     2,     2,     2,    68,
     2,    30,     2,    52,     2,     2,    82,     2,     2,    83,
     2,    88,    29,     2,     2,    92,    52,    52,    52,    93,
    38,    27,    10,    52,    52,    52,    52,    52,    52,    52,
     9,    52,     1,    52,     7,    52,    52,   101,    52,    52,
   102,    52,   103,   106,    52,    52,   112,     7,     7,     7,
   113,   114,   115,   116,     7,     7,     7,     7,     7,     7,
     7,   117,     7,   120,     7,     8,     7,     7,   122,     7,
     7,   123,     7,   124,   nil,     7,     7,   nil,     8,     8,
     8,   nil,   nil,   nil,   nil,     8,     8,     8,     8,     8,
     8,     8,   nil,     8,   nil,     8,    99,     8,     8,   nil,
     8,     8,   nil,     8,   nil,   nil,     8,     8,   nil,    99,
    99,    99,   nil,   nil,   nil,   nil,    99,    99,    99,    99,
    99,    99,    99,   nil,    99,   nil,    99,    98,    99,    99,
   nil,    99,    99,   nil,    99,   nil,   nil,    99,    99,   nil,
    98,    98,    98,   nil,   nil,   nil,   nil,    98,    98,    98,
    98,    98,    98,    98,   nil,    98,   nil,    98,    49,    98,
    98,   nil,    98,    98,   nil,    98,   nil,   nil,    98,    98,
   nil,    49,    49,    49,   nil,   nil,   nil,   nil,    49,    49,
    49,    49,    49,    49,    49,   nil,    49,   nil,    49,    48,
    49,    49,   nil,    49,    49,   nil,    49,   nil,   nil,    49,
    49,   nil,    48,    48,    48,   nil,   nil,   nil,   nil,    48,
    48,    48,    48,    48,    48,    48,   nil,    48,   nil,    48,
    97,    48,    48,   nil,    48,    48,   nil,    48,   nil,   nil,
    48,    48,   nil,    97,    97,    97,   nil,   nil,   nil,   nil,
    97,    97,    97,    97,    97,    97,    97,   nil,    97,   nil,
    97,    47,    97,    97,   nil,    97,    97,   nil,    97,   nil,
   nil,    97,    97,   nil,    47,    47,    47,   nil,   nil,   nil,
   nil,    47,    47,    47,    47,    47,    47,    47,   nil,    47,
   nil,    47,    46,    47,    47,   nil,    47,    47,   nil,    47,
   nil,   nil,    47,    47,   nil,    46,    46,    46,   nil,   nil,
   nil,   nil,    46,    46,    46,    46,    46,    46,    46,   nil,
    46,   nil,    46,    45,    46,    46,   nil,    46,    46,   nil,
    46,   nil,   nil,    46,    46,   nil,    45,    45,    45,   nil,
   nil,   nil,   nil,    45,    45,    45,    45,    45,    45,    45,
   nil,    45,   nil,    45,    44,    45,    45,   nil,    45,    45,
   nil,    45,   nil,   nil,    45,    45,   nil,    44,    44,    44,
   nil,   nil,   nil,   nil,    44,    44,    44,    44,    44,    44,
    44,   nil,    44,   nil,    44,    43,    44,    44,   nil,    44,
    44,   nil,    44,   nil,   nil,    44,    44,   nil,    43,    43,
    43,   nil,   nil,   nil,   nil,    43,    43,    43,    43,    43,
    43,    43,   nil,    43,   nil,    43,    40,    43,    43,   nil,
    43,    43,   nil,    43,   nil,   nil,    43,    43,   nil,    40,
    40,    40,   nil,   nil,   nil,   nil,    40,    40,    40,    40,
    40,    40,    40,   nil,    40,   nil,    40,    42,    40,    40,
   nil,    40,    40,   nil,    40,   nil,   nil,    40,    40,   nil,
    42,    42,    42,   nil,   nil,   nil,   nil,    42,    42,    42,
    42,    42,    42,    42,   nil,    42,   nil,    42,    41,    42,
    42,   nil,    42,    42,   nil,    42,   nil,   nil,    42,    42,
   nil,    41,    41,    41,   nil,   nil,   nil,   nil,    41,    41,
    41,    41,    41,    41,    41,   nil,    41,   nil,    41,    53,
    41,    41,   nil,    41,    41,   nil,    41,   nil,   nil,    41,
    41,   nil,    53,    53,    53,   nil,   nil,   nil,   nil,    53,
    53,    53,    53,    53,    53,    53,   nil,    53,   nil,    53,
    39,    53,    53,   nil,    53,    53,   nil,    53,   nil,   nil,
    53,    53,   nil,    39,    39,    39,   nil,   nil,   nil,   nil,
    39,    39,    39,    39,    39,    39,    39,   nil,    39,   nil,
    39,    56,    39,    39,   nil,    39,    39,   nil,    39,   nil,
   nil,    39,    39,   nil,    56,    56,    56,   nil,   nil,   nil,
   nil,    56,    56,    56,    56,    56,    56,    56,   nil,    56,
   nil,    56,   nil,    56,    56,   nil,    56,    56,   nil,    56,
   nil,   nil,    56,    56,    90,    90,    90,    90,    90,    90,
   nil,    90,   nil,    90,   nil,    90,    90,   nil,    90,    90,
   nil,    90,   nil,   nil,    90,    90,    55,    55,    55,    55,
    55,    55,   nil,    55,   nil,    55,   nil,    55,    55,   nil,
    55,    55,   nil,    55,   nil,   nil,    55,    55,    28,    28,
    28,    28,    28,    28,   nil,    28,   nil,    28,   nil,    28,
    28,   nil,    28,    28,   nil,    28,    18,   nil,    28,    28,
    18,   nil,    18,   nil,    18,   nil,    18,    18,   nil,    18,
    18,   nil,    18 ]

racc_action_pointer = [
    -2,   122,    60,   nil,    -3,   nil,   nil,   122,   153,   118,
   110,   nil,   nil,   nil,   nil,    -2,   nil,   nil,   732,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    82,   715,    69,
    89,    58,    48,   nil,   nil,    15,    10,    34,   107,   618,
   494,   556,   525,   463,   432,   401,   370,   339,   277,   246,
   nil,   nil,    91,   587,    47,   693,   649,   nil,     8,    55,
   -12,    62,    37,    42,    54,    55,    56,    38,    45,   nil,
    12,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    93,    96,   nil,   nil,   nil,   nil,    83,   nil,
   671,   nil,   102,    78,     9,   nil,   nil,   308,   215,   184,
    29,   109,   112,   113,   nil,   nil,    97,   nil,   nil,   nil,
   nil,   nil,   117,   121,   121,   139,   123,   131,   nil,   nil,
   132,   nil,   140,   142,   143,   nil ]

racc_action_default = [
    -1,   -59,    -1,    -6,   -22,    -8,    -9,    -1,    -1,   -59,
   -59,   -26,   -27,   -28,   -29,   -30,   -31,   -32,   -59,   -34,
   -35,   -36,   -37,   -38,   -39,   -40,   -41,   -59,   -44,   -59,
   -59,   -59,   -59,   -51,   -54,   -59,   -59,   -59,   -59,    -1,
    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
   -20,   -21,    -1,    -1,   -59,   -59,    -1,   -33,   -59,   -59,
   -30,   -59,   -45,   -59,   -59,   -59,   -59,   -59,   -59,   126,
   -59,    -7,   -10,   -11,   -12,   -13,   -14,   -15,   -16,   -17,
   -18,   -19,   -59,   -59,   -52,   -53,   -55,   -56,   -59,   -43,
   -44,   -47,   -59,   -59,   -59,   -57,   -58,    -1,    -1,    -1,
    -1,   -59,   -59,   -59,   -46,   -48,   -59,   -50,    -2,    -3,
    -4,    -5,   -59,   -59,   -59,   -59,   -59,   -59,   -42,   -49,
   -24,   -25,   -59,   -59,   -59,   -23 ]

racc_goto_table = [
     1,    62,    38,    61,    57,   nil,   nil,    50,    51,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    86,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    71,
    72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
   nil,   nil,    82,    83,   nil,   nil,    87,   nil,   nil,   nil,
   nil,   nil,   nil,    62,   nil,   104,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   108,   109,   110,
   111 ]

racc_goto_check = [
     1,     3,     1,    17,     6,   nil,   nil,     1,     1,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     3,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
   nil,   nil,     1,     1,   nil,   nil,     1,   nil,   nil,   nil,
   nil,   nil,   nil,     3,   nil,    17,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     1,     1,     1,
     1 ]

racc_goto_pointer = [
   nil,     0,   nil,   -27,   nil,   nil,   -14,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   -25 ]

racc_goto_default = [
   nil,   nil,     3,     4,     5,     6,    11,    12,    13,    19,
    20,    21,    22,    23,    24,    25,    26,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 46, :_reduce_1,
  5, 46, :_reduce_2,
  5, 46, :_reduce_3,
  5, 46, :_reduce_4,
  5, 46, :_reduce_5,
  1, 46, :_reduce_none,
  3, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  3, 46, :_reduce_10,
  3, 46, :_reduce_11,
  3, 46, :_reduce_12,
  3, 46, :_reduce_13,
  3, 46, :_reduce_14,
  3, 46, :_reduce_15,
  3, 46, :_reduce_16,
  3, 46, :_reduce_17,
  3, 46, :_reduce_18,
  3, 46, :_reduce_19,
  2, 46, :_reduce_20,
  2, 46, :_reduce_21,
  1, 46, :_reduce_none,
  11, 49, :_reduce_23,
  7, 49, :_reduce_24,
  7, 50, :_reduce_25,
  1, 48, :_reduce_none,
  1, 48, :_reduce_none,
  1, 48, :_reduce_28,
  1, 48, :_reduce_29,
  1, 48, :_reduce_30,
  1, 48, :_reduce_31,
  1, 48, :_reduce_32,
  2, 52, :_reduce_33,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  1, 51, :_reduce_none,
  6, 61, :_reduce_42,
  3, 60, :_reduce_43,
  0, 62, :_reduce_44,
  1, 62, :_reduce_none,
  3, 62, :_reduce_none,
  3, 59, :_reduce_47,
  4, 54, :_reduce_48,
  6, 57, :_reduce_49,
  4, 55, :_reduce_50,
  1, 56, :_reduce_51,
  3, 56, :_reduce_52,
  3, 56, :_reduce_53,
  1, 58, :_reduce_54,
  3, 58, :_reduce_55,
  3, 47, :_reduce_56,
  3, 53, :_reduce_57,
  3, 53, :_reduce_58 ]

racc_reduce_n = 59

racc_shift_n = 126

racc_token_table = {
  false => 0,
  :error => 1,
  :LPAREN => 2,
  :RPAREN => 3,
  :ANDTOK => 4,
  :ORTOK => 5,
  :ADD => 6,
  :SUB => 7,
  :SEMICOLON => 8,
  :EQ => 9,
  :GT => 10,
  :LT => 11,
  :LE => 12,
  :GE => 13,
  :NE => 14,
  :PUTSTOK => 15,
  :PRINTTOK => 16,
  :IFTOK => 17,
  :OBRACE => 18,
  :BLOCK => 19,
  :EBRACE => 20,
  :ELSETOK => 21,
  :WHILETOK => 22,
  :DIGITS => 23,
  :VAR => 24,
  :HEXVALUE => 25,
  :IPV4ADDR => 26,
  :NOTTOK => 27,
  :DEFTOK => 28,
  :ARGS_DEF => 29,
  :FUNCTOK => 30,
  :COMMA => 31,
  :BACKTICK => 32,
  :DATA => 33,
  :TYPETOK => 34,
  :SETMODETOK => 35,
  :SYMBOL => 36,
  :GETMODETOK => 37,
  :VARDECTOK => 38,
  :VARDECAMT => 39,
  :VARINCTOK => 40,
  :VARINCAMT => 41,
  :EQUAL => 42,
  :QUOTE => 43,
  :SINGLE_QUOTE => 44 }

racc_nt_base = 45

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "LPAREN",
  "RPAREN",
  "ANDTOK",
  "ORTOK",
  "ADD",
  "SUB",
  "SEMICOLON",
  "EQ",
  "GT",
  "LT",
  "LE",
  "GE",
  "NE",
  "PUTSTOK",
  "PRINTTOK",
  "IFTOK",
  "OBRACE",
  "BLOCK",
  "EBRACE",
  "ELSETOK",
  "WHILETOK",
  "DIGITS",
  "VAR",
  "HEXVALUE",
  "IPV4ADDR",
  "NOTTOK",
  "DEFTOK",
  "ARGS_DEF",
  "FUNCTOK",
  "COMMA",
  "BACKTICK",
  "DATA",
  "TYPETOK",
  "SETMODETOK",
  "SYMBOL",
  "GETMODETOK",
  "VARDECTOK",
  "VARDECAMT",
  "VARINCTOK",
  "VARINCAMT",
  "EQUAL",
  "QUOTE",
  "SINGLE_QUOTE",
  "$start",
  "commands",
  "variable_assignment",
  "truth_stmt",
  "if_stmt",
  "while_stmt",
  "command",
  "not_command",
  "quotedtext",
  "type_cmd",
  "get_mode_cmd",
  "vardec_cmd",
  "set_mode_cmd",
  "varinc_cmd",
  "backtick_cmd",
  "call_func",
  "define_func",
  "args" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'SecLang.y', 5)
  def _reduce_1(val, _values, result)
     result = false 
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 8)
  def _reduce_2(val, _values, result)
                 result = val[1] && val[4]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 12)
  def _reduce_3(val, _values, result)
                 result = val[1] || val[4]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 16)
  def _reduce_4(val, _values, result)
                 result = @s.var_add_var(val[1], val[4])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 20)
  def _reduce_5(val, _values, result)
                 result = @s.var_sub_var(val[1], val[4])
           
    result
  end
.,.,

# reduce 6 omitted

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

module_eval(<<'.,.,', 'SecLang.y', 28)
  def _reduce_10(val, _values, result)
                 result = val[0] && val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 32)
  def _reduce_11(val, _values, result)
                 result = val[0] || val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 37)
  def _reduce_12(val, _values, result)
                 result = @s.is_eq?(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 42)
  def _reduce_13(val, _values, result)
                 result = @s.is_gt?(val[0],val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 47)
  def _reduce_14(val, _values, result)
                 result = @s.is_lt?(val[0],val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 52)
  def _reduce_15(val, _values, result)
                 result = @s.is_le?(val[0],val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 57)
  def _reduce_16(val, _values, result)
                 result = @s.is_ge?(val[0],val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 62)
  def _reduce_17(val, _values, result)
                 result = @s.is_ne?(val[0],val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 67)
  def _reduce_18(val, _values, result)
                 result = @s.var_add_var(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 72)
  def _reduce_19(val, _values, result)
                 result = @s.var_sub_var(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 77)
  def _reduce_20(val, _values, result)
                 result = @s.sec_puts(val[1])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 82)
  def _reduce_21(val, _values, result)
                 result = @s.sec_print(val[1])
           
    result
  end
.,.,

# reduce 22 omitted

module_eval(<<'.,.,', 'SecLang.y', 90)
  def _reduce_23(val, _values, result)
    		result = @s.if_stmt(val[2], val[5], val[9])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 95)
  def _reduce_24(val, _values, result)
    		result = @s.if_stmt(val[2], val[5])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 102)
  def _reduce_25(val, _values, result)
                    @nested_stack.push @tokens
 		result = @s.while_stmt(val[2], val[5])
           
    result
  end
.,.,

# reduce 26 omitted

# reduce 27 omitted

module_eval(<<'.,.,', 'SecLang.y', 114)
  def _reduce_28(val, _values, result)
    		result = StringVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 119)
  def _reduce_29(val, _values, result)
    		result = IntVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 124)
  def _reduce_30(val, _values, result)
                    result = @s.get_var(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 129)
  def _reduce_31(val, _values, result)
    		result = HexVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 134)
  def _reduce_32(val, _values, result)
    		result = IPv4Var.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 141)
  def _reduce_33(val, _values, result)
                      result = val[1] ? false : true
           
    result
  end
.,.,

# reduce 34 omitted

# reduce 35 omitted

# reduce 36 omitted

# reduce 37 omitted

# reduce 38 omitted

# reduce 39 omitted

# reduce 40 omitted

# reduce 41 omitted

module_eval(<<'.,.,', 'SecLang.y', 166)
  def _reduce_42(val, _values, result)
    		result = @s.add_func(val[0], val[1], val[4])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 173)
  def _reduce_43(val, _values, result)
    		result = @s.call_func(val[0], val)
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 177)
  def _reduce_44(val, _values, result)
     result = nil 
    result
  end
.,.,

# reduce 45 omitted

# reduce 46 omitted

module_eval(<<'.,.,', 'SecLang.y', 185)
  def _reduce_47(val, _values, result)
    		result = @s.shell(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 192)
  def _reduce_48(val, _values, result)
    		result = @s.var_type(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 199)
  def _reduce_49(val, _values, result)
    		result = @s.var_set_mode(val[2], val[4])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 206)
  def _reduce_50(val, _values, result)
    		result = @s.var_get_mode(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 213)
  def _reduce_51(val, _values, result)
    		result = @s.var_dec(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 218)
  def _reduce_52(val, _values, result)
    		result = @s.var_dec(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 223)
  def _reduce_53(val, _values, result)
                 	result = @s.var_dec_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 230)
  def _reduce_54(val, _values, result)
    		result = @s.var_inc(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 240)
  def _reduce_55(val, _values, result)
                 	result = @s.var_inc_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 247)
  def _reduce_56(val, _values, result)
    		result = @s.add_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 254)
  def _reduce_57(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 258)
  def _reduce_58(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SecLang


