/* SecLang test Script
 * Runs a series of test
 * Written in SecLang
 */
puts "SecLang test scripts"
puts "--------------------"
print "Test "
print 1
puts "."

puts "\n" /* Can't handle blank puts yet */
puts "a = 3"
a = 3
puts "b = 0x90"
b = 0x90
puts 'c = "Test"'
c = "Test"
puts "d = 10.10.10.10"
d = 10.10.10.10

puts "\n"
print "a + b = "
r = a + b
puts r 
puts r == 147
print "b + a = "
r = b + a
puts r
puts r == 0x93
print "a + c = "
r = a + c
puts r
puts r == 3
print "c + a = "
r = c + a
puts r
puts r == "Tesw"
print "d + a = "
r = d + a
puts r
puts r == 10.10.10.13
print "a + d = "
r = a + d
puts r
puts r == 3
print "d + b = "
r = d + b
puts r
puts r == 10.10.10.154
puts "result+=200"
r+=200
puts r
puts r == 10.10.11.99
