ghdl -a number_splitter.vhd
ghdl -a adder.vhd
# ghdl -a number_splitter_tb.vhd
ghdl -e tb
# ghdl -r number_splitter_tb --vcd=out.vcd --stop-time=20us
# gtkwave out.vcd
