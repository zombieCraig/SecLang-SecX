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

module_eval(<<'...end SecLang.y/module_eval...', 'SecLang.y', 246)
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

...end SecLang.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     2,    36,    37,    44,    45,    35,    38,    39,    40,    41,
    42,    43,    84,     5,     6,    10,    11,    12,    13,    14,
    23,    53,    24,    25,    26,    27,     2,    54,    28,    29,
    48,    30,    49,    50,    31,    32,    48,    79,    49,     5,
     6,    10,    11,    12,    13,    14,    23,    55,    24,    25,
    26,    27,     2,    56,    28,    29,    48,    30,    49,    83,
    31,    32,    74,    75,    62,     5,     6,    10,    11,    12,
    13,    14,    23,    85,    24,    25,    26,    27,     2,    86,
    28,    29,    87,    30,    76,    77,    31,    32,    57,    58,
    92,     5,     6,    10,    11,    12,    13,    14,    23,    93,
    24,    25,    26,    27,     2,    94,    28,    29,    95,    30,
    96,    59,    31,    32,    60,    61,    33,     5,     6,    10,
    11,    12,    13,    14,    23,   101,    24,    25,    26,    27,
     2,   102,    28,    29,   nil,    30,   nil,   nil,    31,    32,
   nil,   nil,   nil,     5,     6,    10,    11,    12,    13,    14,
    23,   nil,    24,    25,    26,    27,     2,   nil,    28,    29,
   nil,    30,   nil,   nil,    31,    32,   nil,   nil,   nil,     5,
     6,    10,    11,    12,    13,    14,    23,   nil,    24,    25,
    26,    27,     2,   nil,    28,    29,   nil,    30,   nil,   nil,
    31,    32,   nil,   nil,   nil,     5,     6,    10,    11,    12,
    13,    14,    23,   nil,    24,    25,    26,    27,     2,   nil,
    28,    29,   nil,    30,   nil,   nil,    31,    32,   nil,   nil,
   nil,     5,     6,    10,    11,    12,    13,    14,    23,   nil,
    24,    25,    26,    27,     2,   nil,    28,    29,   nil,    30,
   nil,   nil,    31,    32,   nil,   nil,   nil,     5,     6,    10,
    11,    12,    13,    14,    23,   nil,    24,    25,    26,    27,
     2,   nil,    28,    29,   nil,    30,   nil,   nil,    31,    32,
   nil,   nil,   nil,     5,     6,    10,    11,    12,    13,    14,
    23,   nil,    24,    25,    26,    27,     2,   nil,    28,    29,
   nil,    30,   nil,   nil,    31,    32,   nil,   nil,   nil,     5,
     6,    10,    11,    12,    13,    14,    23,   nil,    24,    25,
    26,    27,     2,   nil,    28,    29,   nil,    30,   nil,   nil,
    31,    32,   nil,   nil,   nil,     5,     6,    10,    11,    12,
    13,    14,    23,   nil,    24,    25,    26,    27,     2,   nil,
    28,    29,   nil,    30,   nil,   nil,    31,    32,   nil,   nil,
   nil,     5,     6,    10,    11,    12,    13,    14,    23,   nil,
    24,    25,    26,    27,     2,   nil,    28,    29,   nil,    30,
   nil,   nil,    31,    32,   nil,   nil,   nil,     5,     6,    10,
    11,    12,    13,    14,    23,   nil,    24,    25,    26,    27,
     2,   nil,    28,    29,   nil,    30,   nil,   nil,    31,    32,
   nil,   nil,   nil,     5,     6,    10,    11,    12,    13,    14,
    23,   nil,    24,    25,    26,    27,     2,   nil,    28,    29,
   nil,    30,   nil,   nil,    31,    32,   nil,   nil,   nil,     5,
     6,    10,    11,    12,    13,    14,    23,   nil,    24,    25,
    26,    27,     2,   nil,    28,    29,   nil,    30,   nil,   nil,
    31,    32,   nil,   nil,   nil,     5,     6,    10,    11,    12,
    13,    14,    23,   nil,    24,    25,    26,    27,     2,   nil,
    28,    29,   nil,    30,   nil,   nil,    31,    32,   nil,   nil,
   nil,     5,     6,    10,    11,    12,    13,    14,    23,   nil,
    24,    25,    26,    27,     2,   nil,    28,    29,   nil,    30,
   nil,   nil,    31,    32,   nil,   nil,   nil,     5,     6,    10,
    11,    12,    13,    14,    23,   nil,    24,    25,    26,    27,
   nil,   nil,    28,    29,   nil,    30,   nil,   nil,    31,    32,
    10,    80,    12,    13,    14,    23,   nil,    24,    25,    26,
    27,   nil,   nil,    28,    29,   nil,    30,   nil,   nil,    31,
    32,    10,    80,    12,    13,    14,    23,   nil,    24,    25,
    26,    27,   nil,   nil,    28,    29,   nil,    30,    52,   nil,
    31,    32,    23,   nil,    24,    25,    26,    27,   nil,   nil,
    28,    29,   nil,    30,    88,    89,    90,    91 ]

racc_action_check = [
     0,     4,     4,     4,     4,     4,     4,     4,     4,     4,
     4,     4,    57,     0,     0,     0,     0,     0,     0,     0,
     0,    23,     0,     0,     0,     0,    91,    24,     0,     0,
    11,     0,    11,    11,     0,     0,    52,    53,    52,    91,
    91,    91,    91,    91,    91,    91,    91,    25,    91,    91,
    91,    91,     2,    26,    91,    91,    80,    91,    80,    56,
    91,    91,    48,    48,    34,     2,     2,     2,     2,     2,
     2,     2,     2,    58,     2,     2,     2,     2,    90,    59,
     2,     2,    60,     2,    49,    49,     2,     2,    27,    28,
    81,    90,    90,    90,    90,    90,    90,    90,    90,    82,
    90,    90,    90,    90,     5,    83,    90,    90,    84,    90,
    85,    31,    90,    90,    32,    33,     1,     5,     5,     5,
     5,     5,     5,     5,     5,    95,     5,     5,     5,     5,
     6,   101,     5,     5,   nil,     5,   nil,   nil,     5,     5,
   nil,   nil,   nil,     6,     6,     6,     6,     6,     6,     6,
     6,   nil,     6,     6,     6,     6,    89,   nil,     6,     6,
   nil,     6,   nil,   nil,     6,     6,   nil,   nil,   nil,    89,
    89,    89,    89,    89,    89,    89,    89,   nil,    89,    89,
    89,    89,    88,   nil,    89,    89,   nil,    89,   nil,   nil,
    89,    89,   nil,   nil,   nil,    88,    88,    88,    88,    88,
    88,    88,    88,   nil,    88,    88,    88,    88,    50,   nil,
    88,    88,   nil,    88,   nil,   nil,    88,    88,   nil,   nil,
   nil,    50,    50,    50,    50,    50,    50,    50,    50,   nil,
    50,    50,    50,    50,    45,   nil,    50,    50,   nil,    50,
   nil,   nil,    50,    50,   nil,   nil,   nil,    45,    45,    45,
    45,    45,    45,    45,    45,   nil,    45,    45,    45,    45,
    36,   nil,    45,    45,   nil,    45,   nil,   nil,    45,    45,
   nil,   nil,   nil,    36,    36,    36,    36,    36,    36,    36,
    36,   nil,    36,    36,    36,    36,    43,   nil,    36,    36,
   nil,    36,   nil,   nil,    36,    36,   nil,   nil,   nil,    43,
    43,    43,    43,    43,    43,    43,    43,   nil,    43,    43,
    43,    43,    42,   nil,    43,    43,   nil,    43,   nil,   nil,
    43,    43,   nil,   nil,   nil,    42,    42,    42,    42,    42,
    42,    42,    42,   nil,    42,    42,    42,    42,    41,   nil,
    42,    42,   nil,    42,   nil,   nil,    42,    42,   nil,   nil,
   nil,    41,    41,    41,    41,    41,    41,    41,    41,   nil,
    41,    41,    41,    41,    40,   nil,    41,    41,   nil,    41,
   nil,   nil,    41,    41,   nil,   nil,   nil,    40,    40,    40,
    40,    40,    40,    40,    40,   nil,    40,    40,    40,    40,
    39,   nil,    40,    40,   nil,    40,   nil,   nil,    40,    40,
   nil,   nil,   nil,    39,    39,    39,    39,    39,    39,    39,
    39,   nil,    39,    39,    39,    39,    38,   nil,    39,    39,
   nil,    39,   nil,   nil,    39,    39,   nil,   nil,   nil,    38,
    38,    38,    38,    38,    38,    38,    38,   nil,    38,    38,
    38,    38,    37,   nil,    38,    38,   nil,    38,   nil,   nil,
    38,    38,   nil,   nil,   nil,    37,    37,    37,    37,    37,
    37,    37,    37,   nil,    37,    37,    37,    37,    35,   nil,
    37,    37,   nil,    37,   nil,   nil,    37,    37,   nil,   nil,
   nil,    35,    35,    35,    35,    35,    35,    35,    35,   nil,
    35,    35,    35,    35,    44,   nil,    35,    35,   nil,    35,
   nil,   nil,    35,    35,   nil,   nil,   nil,    44,    44,    44,
    44,    44,    44,    44,    44,   nil,    44,    44,    44,    44,
   nil,   nil,    44,    44,   nil,    44,   nil,   nil,    44,    44,
    54,    54,    54,    54,    54,    54,   nil,    54,    54,    54,
    54,   nil,   nil,    54,    54,   nil,    54,   nil,   nil,    54,
    54,    55,    55,    55,    55,    55,    55,   nil,    55,    55,
    55,    55,   nil,   nil,    55,    55,   nil,    55,    14,   nil,
    55,    55,    14,   nil,    14,    14,    14,    14,   nil,   nil,
    14,    14,   nil,    14,    62,    62,    62,    62 ]

racc_action_pointer = [
    -2,   116,    50,   nil,    -3,   102,   128,   nil,   nil,   nil,
   nil,    -2,   nil,   nil,   550,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    -2,    25,    45,    51,    86,    87,   nil,
   nil,    88,    91,   115,    61,   466,   258,   440,   414,   388,
   362,   336,   310,   284,   492,   232,   nil,   nil,    45,    67,
   206,   nil,     4,    15,   513,   534,    41,    -6,    55,    43,
    45,   nil,   580,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
    24,    87,    96,   102,    80,   107,   nil,   nil,   180,   154,
    76,    24,   nil,   nil,   nil,    96,   nil,   nil,   nil,   nil,
   nil,   128,   nil ]

racc_action_default = [
    -1,   -52,    -1,    -6,   -20,    -1,    -1,   -21,   -22,   -23,
   -24,   -25,   -26,   -27,   -52,   -29,   -30,   -31,   -32,   -33,
   -34,   -35,   -36,   -52,   -52,   -52,   -52,   -52,   -52,   -43,
   -46,   -52,   -52,   -52,   -52,    -1,    -1,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    -1,    -1,   -18,   -19,   -52,   -52,
    -1,   -28,   -52,   -52,   -52,   -52,   -52,   -52,   -52,   -52,
   -52,   103,   -52,    -7,    -8,    -9,   -10,   -11,   -12,   -13,
   -14,   -15,   -16,   -17,   -44,   -45,   -47,   -48,   -49,   -37,
   -25,   -52,   -52,   -52,   -52,   -52,   -50,   -51,    -1,    -1,
    -1,    -1,   -38,   -39,   -40,   -52,   -42,    -2,    -3,    -4,
    -5,   -52,   -41 ]

racc_goto_table = [
     1,    51,    34,    81,    82,    46,    47,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    63,    64,    65,    66,    67,
    68,    69,    70,    71,    72,    73,   nil,   nil,   nil,   nil,
    78,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    97,    98,
    99,   100 ]

racc_goto_check = [
     1,     4,     1,     3,     3,     1,     1,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,   nil,   nil,   nil,   nil,
     1,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     1,     1,
     1,     1 ]

racc_goto_pointer = [
   nil,     0,   nil,   -51,   -13,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,     3,     4,     7,     8,     9,    15,    16,    17,
    18,    19,    20,    21,    22 ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 39, :_reduce_1,
  5, 39, :_reduce_2,
  5, 39, :_reduce_3,
  5, 39, :_reduce_4,
  5, 39, :_reduce_5,
  1, 39, :_reduce_none,
  3, 39, :_reduce_none,
  3, 39, :_reduce_8,
  3, 39, :_reduce_9,
  3, 39, :_reduce_10,
  3, 39, :_reduce_11,
  3, 39, :_reduce_12,
  3, 39, :_reduce_13,
  3, 39, :_reduce_14,
  3, 39, :_reduce_15,
  3, 39, :_reduce_16,
  3, 39, :_reduce_17,
  2, 39, :_reduce_18,
  2, 39, :_reduce_19,
  1, 39, :_reduce_none,
  1, 41, :_reduce_none,
  1, 41, :_reduce_none,
  1, 41, :_reduce_23,
  1, 41, :_reduce_24,
  1, 41, :_reduce_25,
  1, 41, :_reduce_26,
  1, 41, :_reduce_27,
  2, 43, :_reduce_28,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  3, 52, :_reduce_37,
  4, 48, :_reduce_38,
  4, 49, :_reduce_39,
  4, 45, :_reduce_40,
  6, 47, :_reduce_41,
  4, 46, :_reduce_42,
  1, 50, :_reduce_43,
  3, 50, :_reduce_44,
  3, 50, :_reduce_45,
  1, 51, :_reduce_46,
  3, 51, :_reduce_47,
  3, 51, :_reduce_48,
  3, 40, :_reduce_49,
  3, 44, :_reduce_50,
  3, 44, :_reduce_51 ]

racc_reduce_n = 52

racc_shift_n = 103

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
  :DIGITS => 17,
  :VAR => 18,
  :HEXVALUE => 19,
  :IPV4ADDR => 20,
  :NOTTOK => 21,
  :BACKTICK => 22,
  :DATA => 23,
  :INTTOK => 24,
  :HEXTOK => 25,
  :TYPETOK => 26,
  :SETMODETOK => 27,
  :COMMA => 28,
  :SYMBOL => 29,
  :GETMODETOK => 30,
  :VARDECTOK => 31,
  :VARDECAMT => 32,
  :VARINCTOK => 33,
  :VARINCAMT => 34,
  :EQUAL => 35,
  :QUOTE => 36,
  :SINGLE_QUOTE => 37 }

racc_nt_base = 38

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
  "DIGITS",
  "VAR",
  "HEXVALUE",
  "IPV4ADDR",
  "NOTTOK",
  "BACKTICK",
  "DATA",
  "INTTOK",
  "HEXTOK",
  "TYPETOK",
  "SETMODETOK",
  "COMMA",
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
  "command",
  "not_command",
  "quotedtext",
  "type_cmd",
  "get_mode_cmd",
  "set_mode_cmd",
  "int_cmd",
  "hex_cmd",
  "vardec_cmd",
  "varinc_cmd",
  "backtick_cmd" ]

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

module_eval(<<'.,.,', 'SecLang.y', 26)
  def _reduce_8(val, _values, result)
                 result = val[0] && val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 30)
  def _reduce_9(val, _values, result)
                 result = val[0] || val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 35)
  def _reduce_10(val, _values, result)
                 result = @s.is_eq?(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 40)
  def _reduce_11(val, _values, result)
                 result = val[0] > val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 45)
  def _reduce_12(val, _values, result)
                 result = val[0] < val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 50)
  def _reduce_13(val, _values, result)
                 result = val[0] <= val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 55)
  def _reduce_14(val, _values, result)
                 result = val[0] >= val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 60)
  def _reduce_15(val, _values, result)
                 result = val[0] != val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 65)
  def _reduce_16(val, _values, result)
                 result = @s.var_add_var(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 70)
  def _reduce_17(val, _values, result)
                 result = @s.var_sub_var(val[0], val[2])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 75)
  def _reduce_18(val, _values, result)
                 result = @s.sec_puts(val[1])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 80)
  def _reduce_19(val, _values, result)
                 result = @s.sec_print(val[1])
           
    result
  end
.,.,

# reduce 20 omitted

# reduce 21 omitted

# reduce 22 omitted

module_eval(<<'.,.,', 'SecLang.y', 92)
  def _reduce_23(val, _values, result)
    		result = StringVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 97)
  def _reduce_24(val, _values, result)
    		result = IntVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 102)
  def _reduce_25(val, _values, result)
                    result = @s.get_var(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 107)
  def _reduce_26(val, _values, result)
    		result = HexVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 112)
  def _reduce_27(val, _values, result)
    		result = IPv4Var.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 119)
  def _reduce_28(val, _values, result)
                      result = val[1] ? false : true
           
    result
  end
.,.,

# reduce 29 omitted

# reduce 30 omitted

# reduce 31 omitted

# reduce 32 omitted

# reduce 33 omitted

# reduce 34 omitted

# reduce 35 omitted

# reduce 36 omitted

module_eval(<<'.,.,', 'SecLang.y', 144)
  def _reduce_37(val, _values, result)
    		result = @s.shell(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 151)
  def _reduce_38(val, _values, result)
    		result = @s.int(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 158)
  def _reduce_39(val, _values, result)
    		result = @s.hex(val[2])
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 165)
  def _reduce_40(val, _values, result)
    		result = @s.var_type(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 172)
  def _reduce_41(val, _values, result)
    		result = @s.var_set_mode(val[2], val[4])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 179)
  def _reduce_42(val, _values, result)
    		result = @s.var_get_mode(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 186)
  def _reduce_43(val, _values, result)
    		result = @s.var_dec(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 191)
  def _reduce_44(val, _values, result)
    		result = @s.var_dec(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 196)
  def _reduce_45(val, _values, result)
                 	result = @s.var_dec_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 203)
  def _reduce_46(val, _values, result)
    		result = @s.var_inc(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 208)
  def _reduce_47(val, _values, result)
    		result = @s.var_inc(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 213)
  def _reduce_48(val, _values, result)
                 	result = @s.var_inc_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 220)
  def _reduce_49(val, _values, result)
    		result = @s.add_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 227)
  def _reduce_50(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 231)
  def _reduce_51(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SecLang


