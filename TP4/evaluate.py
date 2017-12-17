#!/usr/bin/python
#!/usr/local/bin/python

MAX_BITS = 32

SOLUTIONS = []

for integer_length in xrange(1,MAX_BITS):
	for fractional_length in xrange(1,MAX_BITS):
		if(integer_length + fractional_length > MAX_BITS):
			continue
		max_int = (2**(integer_length + fractional_length - 1)) - 1
		max_fraction = 2**(fractional_length - 1) - 1
		max_product = (-max_int) * (-max_fraction)
		if len(bin(max_product)) - 2 > MAX_BITS :
			continue
		print str(integer_length + fractional_length) + ":" + str(integer_length) + ":" + str(fractional_length)
		print "MAX INTEGER: " + str(max_int) + "(" + bin(max_int) + ")" + "[" + str(len(bin(max_int))-2) + "]"
		print "MAX FRACTION: " + str(max_fraction) + "(" + bin(max_fraction) + ")" + "[" + str(len(bin(max_fraction))-2) + "]"
		print "MAX PRODUCT: " + str(max_product) + "(" + bin(max_product) + ")" + "[" + str(len(bin(max_product))-2) + "]"
		print "\n\n"