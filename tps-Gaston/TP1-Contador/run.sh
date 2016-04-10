#Anode selector
ghdl -a *.vhd
ghdl -e anode_selector_tb
ghdl -r anode_selector_tb --vcd=out.vcd --stop-time=20us
gtkwave out.vcd

#Anode selector
ghdl -a *.vhd
ghdl -e bcd_counter_tb
ghdl -r bcd_counter_tb --vcd=out.vcd --stop-time=20us
gtkwave out.vcd
