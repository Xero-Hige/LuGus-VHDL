ghdl -a generic_counter.vhd
ghdl -a generic_counter_tb.vhd
ghdl -e generic_counter_tb
ghdl -r generic_counter_tb --vcd=out.vcd --stop-time=4sec --disp-time
gtkwave out.vcd
