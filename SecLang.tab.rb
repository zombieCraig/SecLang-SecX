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

module_eval(<<'...end SecLang.y/module_eval...', 'SecLang.y', 302)
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

...end SecLang.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     2,    33,    34,    32,    35,    36,    37,    38,    39,    40,
    41,    62,     7,     8,     9,    10,    11,    21,    22,    23,
    24,     2,    61,    25,    26,    42,    27,    43,    44,    45,
    28,    60,    29,     7,     8,     9,    10,    11,    21,    22,
    23,    24,     2,    88,    25,    26,    42,    27,    43,    44,
    45,    28,    89,    29,     7,     8,     9,    10,    11,    21,
    22,    23,    24,     2,    90,    25,    26,    42,    27,    43,
    44,    45,    28,    91,    29,     7,     8,     9,    10,    11,
    21,    22,    23,    24,     2,    92,    25,    26,    42,    27,
    43,    44,    45,    28,    59,    29,     7,     8,     9,    10,
    11,    21,    22,    23,    24,     2,    58,    25,    26,    57,
    27,    93,    94,    96,    28,    97,    29,     7,     8,     9,
    10,    11,    21,    22,    23,    24,    52,    98,    25,    26,
    99,    27,    75,    76,   100,    28,    56,    29,    50,    51,
    77,    78,    30,    21,    22,    23,    24,     2,   103,    25,
    26,   104,    27,    73,    74,   105,    28,   106,    29,     7,
     8,     9,    10,    11,    21,    22,    23,    24,     2,   nil,
    25,    26,   nil,    27,   nil,   nil,   nil,    28,   nil,    29,
     7,     8,     9,    10,    11,    21,    22,    23,    24,     2,
   nil,    25,    26,   nil,    27,   nil,   nil,   nil,    28,   nil,
    29,     7,     8,     9,    10,    11,    21,    22,    23,    24,
     2,   nil,    25,    26,   nil,    27,   nil,   nil,   nil,    28,
   nil,    29,     7,     8,     9,    10,    11,    21,    22,    23,
    24,    85,   nil,    25,    26,   nil,    27,   nil,   nil,   nil,
    28,   nil,    29,    81,    79,    84,    83,   nil,    21,    22,
    23,    24,     2,   nil,    25,    26,   nil,    27,   nil,   nil,
   nil,    28,   nil,    29,     7,     8,     9,    10,    11,    21,
    22,    23,    24,     2,   nil,    25,    26,   nil,    27,   nil,
   nil,   nil,    28,   nil,    29,     7,     8,     9,    10,    11,
    21,    22,    23,    24,     2,   nil,    25,    26,   nil,    27,
   nil,   nil,   nil,    28,   nil,    29,     7,     8,     9,    10,
    11,    21,    22,    23,    24,     2,   nil,    25,    26,   nil,
    27,   nil,   nil,   nil,    28,   nil,    29,     7,     8,     9,
    10,    11,    21,    22,    23,    24,     2,   nil,    25,    26,
   nil,    27,   nil,   nil,   nil,    28,   nil,    29,     7,     8,
     9,    10,    11,    21,    22,    23,    24,     2,   nil,    25,
    26,   nil,    27,   nil,   nil,   nil,    28,   nil,    29,     7,
     8,     9,    10,    11,    21,    22,    23,    24,   nil,   nil,
    25,    26,   nil,    27,   nil,    55,    47,    28,   nil,    29,
    21,    22,    23,    24,   nil,   nil,    25,    26,   nil,    27,
   nil,   nil,    47,    28,   nil,    29,    21,    22,    23,    24,
   nil,   nil,    25,    26,   nil,    27 ]

racc_action_check = [
     0,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,    31,     0,     0,     0,     0,     0,     0,     0,     0,
     0,    94,    30,     0,     0,    79,     0,    79,    79,    79,
     0,    29,     0,    94,    94,    94,    94,    94,    94,    94,
    94,    94,     2,    56,    94,    94,     8,    94,     8,     8,
     8,    94,    57,    94,     2,     2,     2,     2,     2,     2,
     2,     2,     2,    40,    58,     2,     2,    51,     2,    51,
    51,    51,     2,    59,     2,    40,    40,    40,    40,    40,
    40,    40,    40,    40,    39,    60,    40,    40,    47,    40,
    47,    47,    47,    40,    28,    40,    39,    39,    39,    39,
    39,    39,    39,    39,    39,    38,    25,    39,    39,    24,
    39,    62,    62,    86,    39,    87,    39,    38,    38,    38,
    38,    38,    38,    38,    38,    38,    21,    88,    38,    38,
    89,    38,    43,    43,    90,    38,    23,    38,    21,    21,
    44,    44,     1,    21,    21,    21,    21,    37,    95,    21,
    21,    97,    21,    42,    42,    99,    21,   105,    21,    37,
    37,    37,    37,    37,    37,    37,    37,    37,    93,   nil,
    37,    37,   nil,    37,   nil,   nil,   nil,    37,   nil,    37,
    93,    93,    93,    93,    93,    93,    93,    93,    93,    85,
   nil,    93,    93,   nil,    93,   nil,   nil,   nil,    93,   nil,
    93,    85,    85,    85,    85,    85,    85,    85,    85,    85,
    36,   nil,    85,    85,   nil,    85,   nil,   nil,   nil,    85,
   nil,    85,    36,    36,    36,    36,    36,    36,    36,    36,
    36,    45,   nil,    36,    36,   nil,    36,   nil,   nil,   nil,
    36,   nil,    36,    45,    45,    45,    45,   nil,    45,    45,
    45,    45,    34,   nil,    45,    45,   nil,    45,   nil,   nil,
   nil,    45,   nil,    45,    34,    34,    34,    34,    34,    34,
    34,    34,    34,    35,   nil,    34,    34,   nil,    34,   nil,
   nil,   nil,    34,   nil,    34,    35,    35,    35,    35,    35,
    35,    35,    35,    35,    41,   nil,    35,    35,   nil,    35,
   nil,   nil,   nil,    35,   nil,    35,    41,    41,    41,    41,
    41,    41,    41,    41,    41,    32,   nil,    41,    41,   nil,
    41,   nil,   nil,   nil,    41,   nil,    41,    32,    32,    32,
    32,    32,    32,    32,    32,    32,    33,   nil,    32,    32,
   nil,    32,   nil,   nil,   nil,    32,   nil,    32,    33,    33,
    33,    33,    33,    33,    33,    33,    33,    52,   nil,    33,
    33,   nil,    33,   nil,   nil,   nil,    33,   nil,    33,    52,
    52,    52,    52,    52,    52,    52,    52,    52,   nil,   nil,
    52,    52,   nil,    52,   nil,    22,    22,    52,   nil,    52,
    22,    22,    22,    22,   nil,   nil,    22,    22,   nil,    22,
   nil,   nil,    11,    22,   nil,    22,    11,    11,    11,    11,
   nil,   nil,    11,    11,   nil,    11 ]

racc_action_pointer = [
    -2,   142,    40,    -3,   nil,   nil,   nil,   nil,    19,   nil,
   nil,   387,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   124,   371,   134,   107,   104,   nil,   nil,    61,    -2,
    22,     8,   313,   334,   250,   271,   208,   145,   103,    82,
    61,   292,   139,   118,   126,   229,   nil,    61,   nil,   nil,
   nil,    40,   355,   nil,   nil,   nil,    28,    37,    49,    41,
    51,   nil,   107,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    -2,
   nil,   nil,   nil,   nil,   nil,   187,   110,    95,   124,   107,
   131,   nil,   nil,   166,    19,   145,   nil,   136,   nil,   131,
   nil,   nil,   nil,   nil,   nil,   154,   nil ]

racc_action_default = [
    -1,   -61,    -1,   -14,   -15,   -16,   -17,   -18,   -19,   -20,
   -21,   -61,   -23,   -24,   -25,   -26,   -27,   -28,   -29,   -30,
   -31,   -61,   -61,   -61,   -61,   -61,   -44,   -47,   -61,   -61,
   -61,   -61,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
    -1,    -1,   -61,   -61,   -61,   -61,   -22,   -61,   -32,   -33,
   -34,   -35,    -1,   -37,   -38,   -39,   -61,   -61,   -61,   -61,
   -61,   107,   -61,    -4,    -5,    -6,    -7,    -8,    -9,   -10,
   -11,   -12,   -13,   -45,   -46,   -48,   -49,   -50,   -51,   -53,
   -52,   -54,   -55,   -56,   -57,    -1,   -61,   -61,   -61,   -61,
   -61,   -59,   -60,    -1,    -1,   -61,   -36,   -61,   -41,   -61,
   -43,    -2,    -3,   -58,   -40,   -61,   -42 ]

racc_goto_table = [
     1,    87,    31,    49,    54,   nil,   nil,   nil,    46,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    48,    53,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    82,   nil,   nil,
   nil,   nil,    63,    64,    65,    66,    67,    68,    69,    70,
    71,    72,    80,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    86,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    95,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   101,   102 ]

racc_goto_check = [
     1,    15,     1,     5,     5,   nil,   nil,   nil,     3,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     3,     3,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     5,   nil,   nil,
   nil,   nil,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     3,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     1,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     1,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,     1,     1 ]

racc_goto_pointer = [
   nil,     0,   nil,    -3,   nil,   -18,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   -54 ]

racc_goto_default = [
   nil,   nil,     3,     4,     5,     6,    12,    13,    14,    15,
    16,    17,    18,    19,    20,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 36, :_reduce_1,
  5, 36, :_reduce_2,
  5, 36, :_reduce_3,
  3, 36, :_reduce_none,
  3, 36, :_reduce_5,
  3, 36, :_reduce_6,
  3, 36, :_reduce_7,
  3, 36, :_reduce_8,
  3, 36, :_reduce_9,
  3, 36, :_reduce_10,
  3, 36, :_reduce_11,
  3, 36, :_reduce_12,
  3, 36, :_reduce_13,
  1, 36, :_reduce_none,
  1, 37, :_reduce_none,
  1, 37, :_reduce_none,
  1, 37, :_reduce_17,
  1, 37, :_reduce_18,
  1, 37, :_reduce_19,
  1, 37, :_reduce_20,
  1, 37, :_reduce_21,
  2, 39, :_reduce_22,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  2, 41, :_reduce_32,
  2, 41, :_reduce_33,
  2, 41, :_reduce_34,
  2, 41, :_reduce_35,
  4, 41, :_reduce_36,
  2, 42, :_reduce_37,
  2, 42, :_reduce_38,
  0, 50, :_reduce_39,
  5, 42, :_reduce_40,
  4, 43, :_reduce_41,
  6, 45, :_reduce_42,
  4, 44, :_reduce_43,
  1, 46, :_reduce_44,
  3, 46, :_reduce_45,
  3, 46, :_reduce_46,
  1, 47, :_reduce_47,
  3, 47, :_reduce_48,
  3, 47, :_reduce_49,
  3, 48, :_reduce_50,
  3, 48, :_reduce_51,
  3, 49, :_reduce_52,
  3, 49, :_reduce_53,
  3, 49, :_reduce_54,
  3, 49, :_reduce_55,
  3, 49, :_reduce_56,
  3, 49, :_reduce_57,
  5, 49, :_reduce_58,
  3, 40, :_reduce_59,
  3, 40, :_reduce_60 ]

racc_reduce_n = 61

racc_shift_n = 107

racc_token_table = {
  false => 0,
  :error => 1,
  :LPAREN => 2,
  :RPAREN => 3,
  :ANDTOK => 4,
  :ORTOK => 5,
  :SEMICOLON => 6,
  :EQ => 7,
  :GT => 8,
  :LT => 9,
  :LE => 10,
  :GE => 11,
  :NE => 12,
  :ADD => 13,
  :DIGITS => 14,
  :VAR => 15,
  :HEXVALUE => 16,
  :IPV4ADDR => 17,
  :NOTTOK => 18,
  :PUTSTOK => 19,
  :PRINTTOK => 20,
  :TYPETOK => 21,
  :SETMODETOK => 22,
  :COMMA => 23,
  :SYMBOL => 24,
  :GETMODETOK => 25,
  :VARDECTOK => 26,
  :VARDECAMT => 27,
  :VARINCTOK => 28,
  :VARINCAMT => 29,
  :SUB => 30,
  :EQUAL => 31,
  :QUOTE => 32,
  :DATA => 33,
  :SINGLE_QUOTE => 34 }

racc_nt_base = 35

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
  "SEMICOLON",
  "EQ",
  "GT",
  "LT",
  "LE",
  "GE",
  "NE",
  "ADD",
  "DIGITS",
  "VAR",
  "HEXVALUE",
  "IPV4ADDR",
  "NOTTOK",
  "PUTSTOK",
  "PRINTTOK",
  "TYPETOK",
  "SETMODETOK",
  "COMMA",
  "SYMBOL",
  "GETMODETOK",
  "VARDECTOK",
  "VARDECAMT",
  "VARINCTOK",
  "VARINCAMT",
  "SUB",
  "EQUAL",
  "QUOTE",
  "DATA",
  "SINGLE_QUOTE",
  "$start",
  "commands",
  "truth_stmt",
  "command",
  "not_command",
  "quotedtext",
  "puts_cmd",
  "print_cmd",
  "type_cmd",
  "get_mode_cmd",
  "set_mode_cmd",
  "vardec_cmd",
  "varinc_cmd",
  "sub_cmd",
  "variable_assignment",
  "@1" ]

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

# reduce 4 omitted

module_eval(<<'.,.,', 'SecLang.y', 17)
  def _reduce_5(val, _values, result)
                 result = val[0] && val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 21)
  def _reduce_6(val, _values, result)
                 result = val[0] || val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 26)
  def _reduce_7(val, _values, result)
                 result = val[0] == val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 31)
  def _reduce_8(val, _values, result)
                 result = val[0] > val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 36)
  def _reduce_9(val, _values, result)
                 result = val[0] < val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 41)
  def _reduce_10(val, _values, result)
                 result = val[0] <= val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 46)
  def _reduce_11(val, _values, result)
                 result = val[0] >= val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 51)
  def _reduce_12(val, _values, result)
                 result = val[0] != val[2]
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 56)
  def _reduce_13(val, _values, result)
                 result = @s.var_add_var(val[0], val[2])
           
    result
  end
.,.,

# reduce 14 omitted

# reduce 15 omitted

# reduce 16 omitted

module_eval(<<'.,.,', 'SecLang.y', 68)
  def _reduce_17(val, _values, result)
    		result = StringVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 73)
  def _reduce_18(val, _values, result)
    		result = IntVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 78)
  def _reduce_19(val, _values, result)
                    result = @s.get_var(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 83)
  def _reduce_20(val, _values, result)
    		result = HexVar.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 88)
  def _reduce_21(val, _values, result)
    		result = IPv4Var.new(val[0])
           
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 95)
  def _reduce_22(val, _values, result)
                      result = val[1] ? false : true
           
    result
  end
.,.,

# reduce 23 omitted

# reduce 24 omitted

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

# reduce 28 omitted

# reduce 29 omitted

# reduce 30 omitted

# reduce 31 omitted

module_eval(<<'.,.,', 'SecLang.y', 122)
  def _reduce_32(val, _values, result)
    		result = puts(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 127)
  def _reduce_33(val, _values, result)
     		result = puts(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 132)
  def _reduce_34(val, _values, result)
    		result = puts(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 137)
  def _reduce_35(val, _values, result)
    		result = puts(@s.var_value(val[1]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 142)
  def _reduce_36(val, _values, result)
    		result = puts(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 149)
  def _reduce_37(val, _values, result)
    		result = print(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 154)
  def _reduce_38(val, _values, result)
    		result = print(val[1])
	  
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 159)
  def _reduce_39(val, _values, result)
    		result = print(val[1])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 163)
  def _reduce_40(val, _values, result)
    		result = print(@s.var_value(val[1]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 170)
  def _reduce_41(val, _values, result)
    		result = @s.var_type(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 177)
  def _reduce_42(val, _values, result)
    		result = @s.var_set_mode(val[2], val[4])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 184)
  def _reduce_43(val, _values, result)
    		result = @s.var_get_mode(val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 191)
  def _reduce_44(val, _values, result)
    		result = @s.var_dec(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 196)
  def _reduce_45(val, _values, result)
    		result = @s.var_dec(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 201)
  def _reduce_46(val, _values, result)
                 	result = @s.var_dec_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 208)
  def _reduce_47(val, _values, result)
    		result = @s.var_inc(val[0])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 213)
  def _reduce_48(val, _values, result)
    		result = @s.var_inc(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 218)
  def _reduce_49(val, _values, result)
                 	result = @s.var_inc_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 225)
  def _reduce_50(val, _values, result)
    		result = @s.var_sub(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 230)
  def _reduce_51(val, _values, result)
    		result = @s.var_sub_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 237)
  def _reduce_52(val, _values, result)
                    r = val[2]
                if r.is_a? SecVar
                  result = @s.add_var(val[0], r)
                elsif r.is_a? Integer
		  result = @s.add_var(val[0], IntVar.new(val[2]))
                else r.is_a? String
		  result = @s.add_var(val[0], StringVar.new(val[2]))
                end
		result
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 250)
  def _reduce_53(val, _values, result)
    		result = @s.copy_var(val[0], val[2])
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 255)
  def _reduce_54(val, _values, result)
    		result = @s.add_var(val[0], IntVar.new(val[2]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 260)
  def _reduce_55(val, _values, result)
    		result = @s.add_var(val[0], StringVar.new(val[2]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 265)
  def _reduce_56(val, _values, result)
    		result = @s.add_var(val[0], IPv4Var.new(val[2]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 270)
  def _reduce_57(val, _values, result)
    		result = @s.add_var(val[0], HexVar.new(val[2]))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 275)
  def _reduce_58(val, _values, result)
                    t = val[3]
		result = @s.add_var(val[0], StringVar.new(t.to_s))
          
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 283)
  def _reduce_59(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

module_eval(<<'.,.,', 'SecLang.y', 287)
  def _reduce_60(val, _values, result)
    		result = val[1]
         
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SecLang


