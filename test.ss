/* SecLang test Script
 * Runs a series of test
 * Written in SecLang
 */
puts "SecLang test scripts"
puts "--------------------"
test_cnt = 1
puts "Initial print test " + str(test_cnt) + ".\n\n"

/* Initialize all of vars */
puts "a = 3"
a = 3
puts "b = 0x90"
b = 0x90
puts 'c = "Test"'
c = "Test"
puts "d = 10.10.10.10"
d = 10.10.10.10

test_cnt++
puts "Starting test #" + str(test_cnt) + "\n\n"
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

test_cnt++
puts "\nTest #" + str(test_cnt)
puts "String command + IP"
cmd = "ping -c 1 "
cmd += 172.16.17.1
puts "Command: " + cmd
puts "Testing command..."
r = `$cmd`
puts "Result:"
puts r

test_cnt++
puts "\nTest #$test_cnt (IF/ELSE)"
puts "if (a == b) { puts 'Match' }"
if (a == b) { puts "Match" }
puts "if (a == 3) { puts 'Match' }"
if (a == 3) { puts "Match" }
puts "Multiline IF code block"
if (a == 3) {
  puts "This comes from a multi-line code-block"
  puts "a ($a) == 3 was true"
}
puts "Else test"
puts "testing if a ($a) == 8 was true"
if (a == 8) {
  puts "This comes from a multi-line code-block"
} else {
  puts "a was not == 8"
}

test_cnt++
puts "\nWhile tests #$test_cnt"
puts "while (a < 8)"
while (a < 8) {
  puts " a=$a"
  a++
}
if(a != 8) {
  puts "Error: a should be 8"
}

target = 10.10.10.250
print "Scanning IPs..."
while(target >= 10.10.11.4) {
  print "."
  target++
}
puts "Target found $target"
if (target != 10.10.11.5) {
  puts "Error: target should be 10.10.11.5"
}

