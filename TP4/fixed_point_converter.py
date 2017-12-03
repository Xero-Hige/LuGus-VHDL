#!/usr/bin/python
#!/usr/local/bin/python

import sys

def int_to_bin(number, integer_bits):
	binary_number = bin(number)
	if(len(binary_number) - 2 > total_bits):
		print "\n\n\nERROR: NOT ENOUGH BITS\n\n\n"
	sanitized_binary_number = binary_number[2:]
	missing_zeros = integer_bits - len(sanitized_binary_number)
	binary_to_return = ""
	for i in xrange(missing_zeros):
		binary_to_return = binary_to_return + "0";
	return binary_to_return + sanitized_binary_number


def get_fractional_part(number):
	integer_part = int(number)
	zero_integer = number - integer_part
	return zero_integer

def fraction_to_bin(fraction, fraction_bits):
	binary_to_return = ""
	accum = 0.0
	for i in range(1,fraction_bits+1):
		tmp_value = 2**(-i)
		if accum + tmp_value > fraction:
			binary_to_return = binary_to_return + "0"
		else:
			binary_to_return = binary_to_return + "1"
			accum = accum + tmp_value
	return binary_to_return

def bin_to_fraction(bin):
	accum = 0.0
	for i in range(1,len(bin) + 1):
		tmp_value = 2 ** (-i)
		accum = accum + 0 if bin[i - 1] == '0' else accum + tmp_value
	return accum

def bin_to_float(binary_number):
	length = len(binary_number)
	fractional_part = ""
	integer_part = binary_number[:length/2]
	if(length % 2 == 0): #no point
		fractional_part = binary_number[length/2:]
	else:
		fractional_part = binary_number[length/2 + 1:]
	return int(integer_part, 2) + bin_to_fraction(fractional_part)


args = sys.argv
total_bits = int(args[1])
number = args[2]
number = float(number)

integer_part = int_to_bin(int(number), total_bits/2)
fractional_part = fraction_to_bin(get_fractional_part(number), total_bits/2)

binary_number = integer_part + "." + fractional_part

print "IN BINARY:"
print binary_number
print "BACK TO DECIMAL: "
print bin_to_float(binary_number)

for element in [45.0,
    26.565051177078,
    14.0362434679265,
    7.1250163489018,
    3.57633437499735,
    1.78991060824607,
    0.895173710211074,
    0.447614170860553,
    0.223810500368538,
    0.111905677066207,
    0.0559528918938037,
    0.0279764526170037,
    0.013988227142265,
    0.0069941136753529,
    0.00349705685070401,
    0.00174852842698045 ]:
    binary = int_to_bin(int(element), 16) + fraction_to_bin(get_fractional_part(element), 16)
    print "\"" + binary + "\,      --- " + str(bin_to_float(binary))