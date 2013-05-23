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

module_eval(<<'...end SecLang.y/module_eval...', 'SecLang.y', 255)
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

...end SecLang.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     2,    38,    39,    46,    47,    37,    40,    41,    42,    43,
    44,    45,    87,     5,     6,    10,    11,    12,    13,    14,
    24,    55,    25,    26,    27,    28,    29,     2,    56,    30,
    31,    50,    32,    51,    52,    33,    34,    50,    82,    51,
     5,     6,    10,    11,    12,    13,    14,    24,    57,    25,
    26,    27,    28,    29,     2,    58,    30,    31,    50,    32,
    51,    59,    33,    34,    77,    78,    65,     5,     6,    10,
    11,    12,    13,    14,    24,    88,    25,    26,    27,    28,
    29,     2,    89,    30,    31,    90,    32,    79,    80,    33,
    34,    91,    60,    61,     5,     6,    10,    11,    12,    13,
    14,    24,    96,    25,    26,    27,    28,    29,     2,    97,
    30,    31,    98,    32,    99,   100,    33,    34,   101,    62,
    63,     5,     6,    10,    11,    12,    13,    14,    24,    64,
    25,    26,    27,    28,    29,     2,    35,    30,    31,   106,
    32,   107,   nil,    33,    34,   nil,   nil,   nil,     5,     6,
    10,    11,    12,    13,    14,    24,   nil,    25,    26,    27,
    28,    29,     2,   nil,    30,    31,   nil,    32,   nil,   nil,
    33,    34,   nil,   nil,   nil,     5,     6,    10,    11,    12,
    13,    14,    24,   nil,    25,    26,    27,    28,    29,     2,
   nil,    30,    31,   nil,    32,   nil,   nil,    33,    34,   nil,
   nil,   nil,     5,     6,    10,    11,    12,    13,    14,    24,
   nil,    25,    26,    27,    28,    29,     2,   nil,    30,    31,
   nil,    32,   nil,   nil,    33,    34,   nil,   nil,   nil,     5,
     6,    10,    11,    12,    13,    14,    24,   nil,    25,    26,
    27,    28,    29,     2,   nil,    30,    31,   nil,    32,   nil,
   nil,    33,    34,   nil,   nil,   nil,     5,     6,    10,    11,
    12,    13,    14,    24,   nil,    25,    26,    27,    28,    29,
     2,   nil,    30,    31,   nil,    32,   nil,   nil,    33,    34,
   nil,   nil,   nil,     5,     6,    10,    11,    12,    13,    14,
    24,   nil,    25,    26,    27,    28,    29,     2,   nil,    30,
    31,   nil,    32,   nil,   nil,    33,    34,   nil,   nil,   nil,
     5,     6,    10,    11,    12,    13,    14,    24,   nil,    25,
    26,    27,    28,    29,     2,   nil,    30,    31,   nil,    32,
   nil,   nil,    33,    34,   nil,   nil,   nil,     5,     6,    10,
    11,    12,    13,    14,    24,   nil,    25,    26,    27,    28,
    29,     2,   nil,    30,    31,   nil,    32,   nil,   nil,    33,
    34,   nil,   nil,   nil,     5,     6,    10,    11,    12,    13,
    14,    24,   nil,    25,    26,    27,    28,    29,     2,   nil,
    30,    31,   nil,    32,   nil,   nil,    33,    34,   nil,   nil,
   nil,     5,     6,    10,    11,    12,    13,    14,    24,   nil,
    25,    26,    27,    28,    29,     2,   nil,    30,    31,   nil,
    32,   nil,   nil,    33,    34,   nil,   nil,   nil,     5,     6,
    10,    11,    12,    13,    14,    24,   nil,    25,    26,    27,
    28,    29,     2,   nil,    30,    31,   nil,    32,   nil,   nil,
    33,    34,   nil,   nil,   nil,     5,     6,    10,    11,    12,
    13,    14,    24,   nil,    25,    26,    27,    28,    29,     2,
   nil,    30,    31,   nil,    32,   nil,   nil,    33,    34,   nil,
   nil,   nil,     5,     6,    10,    11,    12,    13,    14,    24,
   nil,    25,    26,    27,    28,    29,     2,   nil,    30,    31,
   nil,    32,   nil,   nil,    33,    34,   nil,   nil,   nil,     5,
     6,    10,    11,    12,    13,    14,    24,   nil,    25,    26,
    27,    28,    29,     2,   nil,    30,    31,   nil,    32,   nil,
   nil,    33,    34,   nil,   nil,   nil,     5,     6,    10,    11,
    12,    13,    14,    24,   nil,    25,    26,    27,    28,    29,
   nil,   nil,    30,    31,   nil,    32,   nil,   nil,    33,    34,
    10,    83,    12,    13,    14,    24,   nil,    25,    26,    27,
    28,    29,   nil,   nil,    30,    31,   nil,    32,   nil,   nil,
    33,    34,    10,    83,    12,    13,    14,    24,   nil,    25,
    26,    27,    28,    29,   nil,   nil,    30,    31,   nil,    32,
   nil,   nil,    33,    34,    10,    83,    12,    13,    14,    24,
   nil,    25,    26,    27,    28,    29,   nil,   nil,    30,    31,
   nil,    32,    54,   nil,    33,    34,    24,   nil,    25,    26,
    27,    28,    29,   nil,   nil,    30,    31,   nil,    32,    92,
    93,    94,    95 ]

racc_action_check = [
     0,     4,     4,     4,     4,     4,     4,     4,     4,     4,
     4,     4,    59,     0,     0,     0,     0,     0,     0,     0,
     0,    24,     0,     0,     0,     0,     0,    95,    25,     0,
     0,    11,     0,    11,    11,     0,     0,    54,    55,    54,
    95,    95,    95,    95,    95,    95,    95,    95,    26,    95,
    95,    95,    95,    95,     2,    27,    95,    95,    83,    95,
    83,    28,    95,    95,    50,    50,    36,     2,     2,     2,
     2,     2,     2,     2,     2,    60,     2,     2,     2,     2,
     2,    94,    61,     2,     2,    62,     2,    51,    51,     2,
     2,    63,    29,    30,    94,    94,    94,    94,    94,    94,
    94,    94,    84,    94,    94,    94,    94,    94,     5,    85,
    94,    94,    86,    94,    87,    88,    94,    94,    89,    33,
    34,     5,     5,     5,     5,     5,     5,     5,     5,    35,
     5,     5,     5,     5,     5,     6,     1,     5,     5,   100,
     5,   106,   nil,     5,     5,   nil,   nil,   nil,     6,     6,
     6,     6,     6,     6,     6,     6,   nil,     6,     6,     6,
     6,     6,    93,   nil,     6,     6,   nil,     6,   nil,   nil,
     6,     6,   nil,   nil,   nil,    93,    93,    93,    93,    93,
    93,    93,    93,   nil,    93,    93,    93,    93,    93,    92,
   nil,    93,    93,   nil,    93,   nil,   nil,    93,    93,   nil,
   nil,   nil,    92,    92,    92,    92,    92,    92,    92,    92,
   nil,    92,    92,    92,    92,    92,    52,   nil,    92,    92,
   nil,    92,   nil,   nil,    92,    92,   nil,   nil,   nil,    52,
    52,    52,    52,    52,    52,    52,    52,   nil,    52,    52,
    52,    52,    52,    47,   nil,    52,    52,   nil,    52,   nil,
   nil,    52,    52,   nil,   nil,   nil,    47,    47,    47,    47,
    47,    47,    47,    47,   nil,    47,    47,    47,    47,    47,
    37,   nil,    47,    47,   nil,    47,   nil,   nil,    47,    47,
   nil,   nil,   nil,    37,    37,    37,    37,    37,    37,    37,
    37,   nil,    37,    37,    37,    37,    37,    45,   nil,    37,
    37,   nil,    37,   nil,   nil,    37,    37,   nil,   nil,   nil,
    45,    45,    45,    45,    45,    45,    45,    45,   nil,    45,
    45,    45,    45,    45,    44,   nil,    45,    45,   nil,    45,
   nil,   nil,    45,    45,   nil,   nil,   nil,    44,    44,    44,
    44,    44,    44,    44,    44,   nil,    44,    44,    44,    44,
    44,    43,   nil,    44,    44,   nil,    44,   nil,   nil,    44,
    44,   nil,   nil,   nil,    43,    43,    43,    43,    43,    43,
    43,    43,   nil,    43,    43,    43,    43,    43,    42,   nil,
    43,    43,   nil,    43,   nil,   nil,    43,    43,   nil,   nil,
   nil,    42,    42,    42,    42,    42,    42,    42,    42,   nil,
    42,    42,    42,    42,    42,    41,   nil,    42,    42,   nil,
    42,   nil,   nil,    42,    42,   nil,   nil,   nil,    41,    41,
    41,    41,    41,    41,    41,    41,   nil,    41,    41,    41,
    41,    41,    40,   nil,    41,    41,   nil,    41,   nil,   nil,
    41,    41,   nil,   nil,   nil,    40,    40,    40,    40,    40,
    40,    40,    40,   nil,    40,    40,    40,    40,    40,    39,
   nil,    40,    40,   nil,    40,   nil,   nil,    40,    40,   nil,
   nil,   nil,    39,    39,    39,    39,    39,    39,    39,    39,
   nil,    39,    39,    39,    39,    39,    38,   nil,    39,    39,
   nil,    39,   nil,   nil,    39,    39,   nil,   nil,   nil,    38,
    38,    38,    38,    38,    38,    38,    38,   nil,    38,    38,
    38,    38,    38,    46,   nil,    38,    38,   nil,    38,   nil,
   nil,    38,    38,   nil,   nil,   nil,    46,    46,    46,    46,
    46,    46,    46,    46,   nil,    46,    46,    46,    46,    46,
   nil,   nil,    46,    46,   nil,    46,   nil,   nil,    46,    46,
    56,    56,    56,    56,    56,    56,   nil,    56,    56,    56,
    56,    56,   nil,   nil,    56,    56,   nil,    56,   nil,   nil,
    56,    56,    58,    58,    58,    58,    58,    58,   nil,    58,
    58,    58,    58,    58,   nil,   nil,    58,    58,   nil,    58,
   nil,   nil,    58,    58,    57,    57,    57,    57,    57,    57,
   nil,    57,    57,    57,    57,    57,   nil,   nil,    57,    57,
   nil,    57,    14,   nil,    57,    57,    14,   nil,    14,    14,
    14,    14,    14,   nil,   nil,    14,    14,   nil,    14,    65,
    65,    65,    65 ]

racc_action_pointer = [
    -2,   136,    52,   nil,    -3,   106,   133,   nil,   nil,   nil,
   nil,    -2,   nil,   nil,   594,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    -2,    26,    46,    53,    59,    90,
    91,   nil,   nil,    96,    97,   129,    63,   268,   484,   457,
   430,   403,   376,   349,   322,   295,   511,   241,   nil,   nil,
    47,    70,   214,   nil,     4,    16,   533,   577,   555,    -6,
    57,    64,    48,    53,   nil,   625,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    25,    99,   106,   109,   111,    86,   115,
   nil,   nil,   187,   160,    79,    25,   nil,   nil,   nil,   nil,
   109,   nil,   nil,   nil,   nil,   nil,   138,   nil ]

racc_action_default = [
    -1,   -54,    -1,    -6,   -20,    -1,    -1,   -21,   -22,   -23,
   -24,   -25,   -26,   -27,   -54,   -29,   -30,   -31,   -32,   -33,
   -34,   -35,   -36,   -37,   -54,   -54,   -54,   -54,   -54,   -54,
   -54,   -45,   -48,   -54,   -54,   -54,   -54,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   -18,   -19,
   -54,   -54,    -1,   -28,   -54,   -54,   -54,   -54,   -54,   -54,
   -54,   -54,   -54,   -54,   108,   -54,    -7,    -8,    -9,   -10,
   -11,   -12,   -13,   -14,   -15,   -16,   -17,   -46,   -47,   -49,
   -50,   -51,   -38,   -25,   -54,   -54,   -54,   -54,   -54,   -54,
   -52,   -53,    -1,    -1,    -1,    -1,   -39,   -40,   -41,   -42,
   -54,   -44,    -2,    -3,    -4,    -5,   -54,   -43 ]

racc_goto_table = [
     1,    53,    36,   nil,   nil,    48,    49,    84,    85,    86,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    66,    67,    68,
    69,    70,    71,    72,    73,    74,    75,    76,   nil,   nil,
   nil,   nil,    81,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   102,   103,   104,   105 ]

racc_goto_check = [
     1,     4,     1,   nil,   nil,     1,     1,     3,     3,     3,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,   nil,   nil,
   nil,   nil,     1,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     1,     1,     1,     1 ]

racc_goto_pointer = [
   nil,     0,   nil,   -49,   -13,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,     3,     4,     7,     8,     9,    15,    16,    17,
    18,    19,    20,    21,    22,    23 ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 40, :_reduce_1,
  5, 40, :_reduce_2,
  5, 40, :_reduce_3,
  5, 40, :_reduce_4,
  5, 40, :_reduce_5,
  1, 40, :_reduce_none,
  3, 40, :_reduce_none,
  3, 40, :_reduce_8,
  3, 40, :_reduce_9,
  3, 40, :_reduce_10,
  3, 40, :_reduce_11,
  3, 40, :_reduce_12,
  3, 40, :_reduce_13,
  3, 40, :_reduce_14,
  3, 40, :_reduce_15,
  3, 40, :_reduce_16,
  3, 40, :_reduce_17,
  2, 40, :_reduce_18,
  2, 40, :_reduce_19,
  1, 40, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_23,
  1, 42, :_reduce_24,
  1, 42, :_reduce_25,
  1, 42, :_reduce_26,
  1, 42, :_reduce_27,
  2, 44, :_reduce_28,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  3, 54, :_reduce_38,
  4, 51, :_reduce_39,
  4, 49, :_reduce_40,
  4, 50, :_reduce_41,
  4, 46, :_reduce_42,
  6, 48, :_reduce_43,
  4, 47, :_reduce_44,
  1, 52, :_reduce_45,
  3, 52, :_reduce_46,
  3, 52, :_reduce_47,
  1, 53, :_reduce_48,
  3, 53, :_reduce_49,
  3, 53, :_reduce_50,
  3, 41, :_reduce_51,
  3, 45, :_reduce_52,
  3, 45, :_reduce_53 ]

racc_reduce_n = 54

racc_shift_n = 108

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
  :STRTOK => 24,
  :INTTOK => 25,
  :HEXTOK => 26,
  :TYPETOK => 27,
  :SETMODETOK => 28,
  :COMMA => 29,
  :SYMBOL => 30,
  :GETMODETOK => 31,
  :VARDECTOK => 32,
  :VARDECAMT => 33,
  :VARINCTOK => 34,
  :VARINCAMT => 35,
  :EQUAL => 36,
  :QUOTE => 37,
  :SINGLE_QUOTE => 38 }

racc_nt_base = 39

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
  "STRTOK",
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
  "str_cmd",
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

# reduce 37 omitted

module_eval(<<'.,.,', 'SecLang.y', 146)
  def _reduce_38(val, _values, result)
    		result = @s.shell(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 153)
  def _reduce_39(val, _values, result)
    		result = @s.str(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 160)
  def _reduce_40(val, _values, result)
    		result = @s.int(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 167)
  def _reduce_41(val, _values, result)
    		result = @s.hex(val[2])
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 174)
  def _reduce_42(val, _values, result)
    		result = @s.var_type(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 181)
  def _reduce_43(val, _values, result)
    		result = @s.var_set_mode(val[2], val[4])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 188)
  def _reduce_44(val, _values, result)
    		result = @s.var_get_mode(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 195)
  def _reduce_45(val, _values, result)
    		result = @s.var_dec(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 200)
  def _reduce_46(val, _values, result)
    		result = @s.var_dec(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 205)
  def _reduce_47(val, _values, result)
                 	result = @s.var_dec_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 212)
  def _reduce_48(val, _values, result)
    		result = @s.var_inc(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 217)
  def _reduce_49(val, _values, result)
    		result = @s.var_inc(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 222)
  def _reduce_50(val, _values, result)
                 	result = @s.var_inc_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 229)
  def _reduce_51(val, _values, result)
    		result = @s.add_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 236)
  def _reduce_52(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 240)
  def _reduce_53(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SecLang


