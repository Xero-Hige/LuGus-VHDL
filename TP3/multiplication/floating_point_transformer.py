#!/usr/local/bin/python
import sys

def binary_to_float(total_bits, exp_bits, binary_string):
	sign = 1 if binary_string[0] is '0' else -1
	bias = 2**(exp_bits - 1) - 1;
	exponent_bits = binary_string[1:exp_bits+1]
	exponent = int(exponent_bits,2) - bias + 1
	mantissa_bits = binary_string[exp_bits + 1:]
	mantissa_bits = '1' + mantissa_bits
	mantissa = mantissa_bits_to_integer(mantissa_bits)
	print str(sign) + " * 0." + mantissa_bits + " x 2^" + str(exponent)
	return sign * mantissa * (2.0**(exponent)) 


def mantissa_bits_to_integer(mantissa_bits):
	number = 0
	position = -1
	for bit in mantissa_bits:
		if bit == '1':
			number = number + (2**position)
		position = position - 1
	return number

def integer_to_float(total_bits, exp_bits, number):
	binary = to_binary(total_bits,number)
	print binary
	return binary_to_float(total_bits, exp_bits, binary)


def to_binary(total_bits, integer):
	actual_bits = bin(integer)[2:]
	size_difference = total_bits - len(actual_bits)
	bits_to_return = ''
	for i in xrange(size_difference):
		bits_to_return = bits_to_return + '0'
	return bits_to_return + actual_bits

args = sys.argv
option = args[1]
total_bits = int(args[2])
exp_bits = int(args[3])

number = args[4]

if(option == '-b'):
	print binary_to_float(total_bits, exp_bits, number)
elif(option == '-i'):
	print integer_to_float(total_bits, exp_bits, int(number))