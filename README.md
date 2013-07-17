SecX Security Language
======================

Overview
--------

This langauge was designed to be used as CLI integration into an applications
menu system.  Specifically it was designed to easily integrate into text
based menu systems that preform security auditing tasks.  The language
can work as a standalone language or you can implement your own callbacks
from your application.

SecLang requires Ruby to run and works best when integrating into a ruby
based project.

*SecLang.irb* is an interactive tool to play with the language.  Example
below are created using this tool.

*test.scX* is a test script we debug with.  View that file for further
examples of usage.

Core Variable Types
-------------------
* Integer
* Float
* Hex
* String
* IPv4

These variables will be automatically created on use.  For example:

```
> target=127.0.0.1
-> 127.0.0.1
> type(target)
-> ipv4
> port=0x1bb
-> 0x1bb
> type(port)
-> hex
```

Each varible has its own special characteristics.  For example:

```
> broadcast = 255.255.255.255
-> 255.255.255.255
> broadcast++
-> 0.0.0.0
> password_attempt="Password1"
-> Password1
> password_attempt++
-> Password2
```

You can add different variable types together and they will be handled in
an intelligent way.  Left operator influence end result type.

```
> 10 + 0x10
-> 26
> 0x10 + 10
-> 0x1a
> port = 0x1bb
-> 0x1bb
> 0.0.0.0 + port
-> 0.0.2.188
> "This is my ip: " + 127.0.0.1
-> This is my ip: 127.0.0.1
```

Strings increment in a brute-force style, example: aa, ab, ac, etc.  The
character set used in incrementing is auto-detected.  You can view the
mode of the string with mode() and change it with set_mode()

Valid options for set_mode(<var>, :<mode>)
* :mixed_case
* :alphanum
* :lower
* :upper
* :hex (although you should create an actual hex varible instead)

Methods
-------
* mode(<str>) - Gets the mod eof a string
* set_mode(<str>, :<mode>) - Sets the mode (see above)
* type(<var>) - Returns the variable type
* int(<var>) - converts to an integer
* hex(<var>) - converts to a hex
* str(<var>) - converts to a string
* (backticks) - Used to execute code on the shell
* puts, print - prints to the console with or w/o a newline respectively
* len(<var>) - Returns length of a string or an array
* rand(<min>, <max>) - Return a random number from min to max
* md5(<str>) - Creates an md5 hash of <str>
* sha256(<str>) - Creates a sha256 has of <str>
* uuencode/uudecode - UU Encodes or Decodes a string
* urlencode/urldecode - Url Encodes or Decodes a string
* fail, info, pass - Logging functions that print a string
* color(<mode>) - Sets default color output to: none, on or full
* black, red, green, yellow, blue, magenta, cyan, grey, bold - sets colors
* def <function>(<arg>,<arg>,...) { } - define your own functions/methods

Conditions
----------
if (condition) { <code> }
if (condition) { <code> } else { <code>}
Conditions:
* ==
* !=
* >
* <
* >=
* <=
* =~ (regex matching)

Iterators
---------
while(condition) { <code> }

Data Structures
---------------
* Arrays *
Arrays are defined using []. Example:

```
> a = [ "my_string", 100, 3.14, 0x30, 127.0.0.1 ]
-> [ my_string, 100, 3.14, 0x30, 127.0.0.1 ]
> len(a)
-> 5
> a[3]
-> 0x30
```

Ruby Integration
----------------
To integrate into your ruby project:
```
require "SecLang/SecLang.tab"
parser = SecLang.new
result = parser.parse "10.10.10.10 + 250"
puts result
```

or if you have a readline loop in your console app:
```
    while buf = Readline.readline(get_prompt, true)
          r = @parser.parse buf
    end
```

* Registering Callbacks *

(TODO - Document the add_func method)

About
-----
This language was an internal project of Theia Labs http://theialabs.com/

It is being released to the public.

It should currently be considered a very alpha state/quality


