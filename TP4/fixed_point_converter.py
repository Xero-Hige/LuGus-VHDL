#!/usr/bin/python
#!/usr/local/bin/python

import sys

ARCTG_TABLE = [	45.0,
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
0.00699411367535292,
0.00349705685070401,
0.00174852842698045]

SCALING_VALUES_TABLE = [1.4142135623731,
1.58113883008419,
1.62980060130066,
1.64248406575224,
1.64568891575725,
1.64649227871248,
1.64669325427364,
1.6467435065969,
1.64675607020488,
1.64675921113982,
1.64675999637562,
1.64676019268469,
1.64676024176197,
1.64676025403129,
1.64676025709862,
1.6467602579,
1.6467602581]


INT_BITS = 16
FRACTION_BITS = 16

def write_arctg_table():
	for value in ARCTG_TABLE:
		integer_part = int_to_bin(int(value), INT_BITS)
		fractional_part = fraction_to_bin(get_fractional_part(value), FRACTION_BITS)
		print '"' + integer_part + fractional_part + '", ---' + str(bin_to_float(integer_part + fractional_part))

def write_scaling_values_table():
	for value in SCALING_VALUES_TABLE:
		value = 1/value
		integer_part = int_to_bin(int(value), INT_BITS)
		fractional_part = fraction_to_bin(get_fractional_part(value), FRACTION_BITS)
		print '"' + integer_part + fractional_part + '", ---' + str(bin_to_float(integer_part + fractional_part))

def int_to_bin(number, integer_bits):
	binary_number = bin(number)
	unused = 2
	if(binary_number[0] == '-'):
		unused = 3
	if(len(binary_number) - unused > total_bits):
		print "\n\n\nERROR: NOT ENOUGH BITS\n\n\n"
	sanitized_binary_number = binary_number[unused:]
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
	integer_part = binary_number[:INT_BITS]
	if(length % 2 == 0): #no point
		fractional_part = binary_number[INT_BITS:]
	else:
		fractional_part = binary_number[INT_BITS + 1:]
	return int(integer_part, 2) + bin_to_fraction(fractional_part)

args = sys.argv
option = args[1]
total_bits = int(args[2])
number = args[3]

if(option == '-f'):
	number = float(number)
	integer_part = int_to_bin(int(number), INT_BITS)
	fractional_part = fraction_to_bin(get_fractional_part(number), FRACTION_BITS)
	print "FIXED POINT BINARY VALUE: "
	print integer_part + "." + fractional_part
elif (option == '-b'):
	print "FRACTIONAL VALUE: "
	print bin_to_float(number)
elif (option == "-i"):
	number = int(number)
	binary = int_to_bin(number, total_bits)
	print str(bin_to_float(binary)) + " (" + binary + ")"
elif (option == "-arctg"):
	write_arctg_table()
elif (option == "-scaling"):
	write_scaling_values_table()

