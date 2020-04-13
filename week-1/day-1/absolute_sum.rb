print "First number: "
a = gets.chomp.to_i(10)
a < 0 ? a *= -1 : nil

print "Second number: "
b = gets.chomp.to_i(10)
b < 0 ? b *= -1 : nil

puts a + b

