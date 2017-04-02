ghdl -a bcd_counter/cont_bcd.vhd
ghdl -a bcd_counter/cont_bcd_tb.vhd
ghdl -e cont_bcd_tb
ghdl -r cont_bcd_tb --vcd=out.vcd --stop-time=20us
gtkwave out.vcd
